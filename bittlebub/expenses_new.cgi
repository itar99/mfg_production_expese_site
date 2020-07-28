#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Template;
use JSON;


use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web_obj = new expenses;

$web_obj->dispatch();
exit;

package expenses;

use parent('iw_web');
use Date::Manip;

our $main = '';
our $web = '';
our $q = '';
our $session = '';
our $path = 'files/expenses';

sub init
{
   my $self = shift;
   $web = $self;
   $q = new CGI;
   
   $main = new iw_admin(database => 'itarswor_production');
   
   $session = $main->get_session();
   if(!$session->param("uid"))
   {
       print $q->redirect("login.cgi");
       exit;
   }

   my $menu = $main->getMenu();
   $path = 'files/expenses';
   
   $web->tplVars(menu => $menu);
}

sub defaultAction
{
   my $start_dt = $q->escapeHTML($q->param("start_dt")) || '';
   my $end_dt = $q->escapeHTML($q->param("end_dt")) || '';
#   my $category = $q->escapeHTML($q->param("category")) || '';
   my $rpp = $q->escapeHTML($q->param("rpp")) || $session->param("rpp");
   my $page = $q->escapeHTML($q->param("p")) || 1;
   
   my %form = %{$web->getVars()};
   
   if (!$rpp) { $rpp = 25; }
   
   my $count = 0;
   
   my $count_sql = qq[select count(*) as count from expenses];
   my $sql = qq[select e.*, ec.name as category_name, p.name as project_name, etc.name as tax_category_name, date_format(e.expense_dt, '%m-%d-%Y') as expense_date
                from expenses e 
                left join expense_category ec on ec.id = e.category
                left join projects p on p.id = e.project
                left join expense_tax_category etc on etc.id = e.tax_category
      ];
   my @values = ();
   
   my @where = ();
   my $format = '%m-%d-%Y';
   if ($start_dt) {
      push(@where, qq[ expense_dt > str_to_date(?, '$format') ]);
      push(@values, $start_dt);
   }
   if ($end_dt) {
      push(@where, qq[ expense_dt < str_to_date(?, '$format') ]);
      push(@values, $end_dt);
   }
#   if ($category) {
#      push(@where, qq[category = ?]);
#      push(@values, $category);
#   }
   
   foreach my $key (keys %form) {
$main->logit("form key [$key] value [$form{$key}]");
      if ($key =~ /^search_/) {
         my $col = $key;
         $col =~ s/search_//;
         if ($form{$key}) {
            push(@where, qq[$col = ?]);
            push(@values, $form{$key});
         }
      }
      
   }
   my $wh = join(" and ", @where);
   $sql .= qq[ where $wh] if($wh);
   
   $count_sql .= qq[ where $wh] if($wh);
   my @count = $main->dbx_select(sql => $count_sql, values => \@values );
   my $max_page = $page;
   if ($count[0]->{count} > $rpp) {
      my $start = 0 + ($rpp * $page);
      my $end = $start + $rpp;
      $count_sql .= qq[ limit $start, $end]; 
   }
   
$main->logit("expense sql [$sql]");
   my @data = $main->dbx_select(sql => $sql, values => \@values);
   
$main->logit("search category [$form{search_category}]");
   $web->tplVars(
     cat_dd =>  $main->MakeDropdown(table => 'expense_category', fields => 'id, name', value => 'id', label => 'name', name => 'search_category', none=>'', match=>$form{search_category}),
     project_dd => $main->MakeDropdown(table => 'projects', fields => 'id, name', value => 'id', label => 'name', name => 'search_project', none=>'', match=>$form{search_project}),
     tax_dd => $main->MakeDropdown(table => 'expense_tax_category', fields => 'id, name', value => 'id', label => 'name', name => 'search_tax_category', none=>'', match=>$form{search_tax_category}),
     rpp_dd => $main->MakeDropdown(static => ['10','25','50'], name=>"rpp", match=>$rpp),
     data => \@data,
     start_dt => $start_dt,
     end_dt => $end_dt,
     page => $page,
     max_page => $max_page,
     title => 'Expense Report'
   );
   
   $web->setTpl('expense.tpl');
   $session->param("rpp",$rpp);
}

sub saveAction
{
   my %form = $q->Vars;
   
   my @files = ();
   
   foreach my $key (keys %form) {
      $form{$key} = $q->escapeHTML($form{$key});
   }

   my $updated_uid = 'entered_uid';
   my $updated_dt = 'entered_dt';
   if ($form{id}) {
      $updated_uid = 'updated_uid';
      $updated_dt = 'updated_dt'
   }
   
   $form{$updated_dt} = UnixDate('now', '%Y-%d-%m %H:%M:%S %p');

   $form{$updated_uid} = $session->{uid};
   my $ret = $main->dbx_save('expenses', \%form, $form{id});
   
   foreach my $key (keys %form) {
      if ($key =~ /^attach_expense_/ && $ret) {
         my $filename = $q->escapeHTML($q->param($key));
         my $file = $main->SaveFile($path, $filename, $key);
         my %data = ();
         $data{expense_id} = $ret;
         $data{filename} = $file;
         $data{file} = $filename;
         
         $main->dbx_save('expense_attachment', \%data, $form{id});
      }
      
   }
   
   my $msg = '';
   if (defined($ret)) {
      $msg = 'Record saved!';
   } else {
      $msg = "There was a problem saving your record";
   }
   
   $web->tplVars(msg => $msg);
   &defaultAction();
}

sub editAction
{
   my $id = $q->escapeHTML($q->param('id')) || '';
   
   my $sql = qq[select e.*, ec.name as category_name, p.name as project_name, etc.name as tax_category_name, date_format(e.expense_dt, '%m-%d-%Y') as expense_date
             from expenses e 
             left join expense_category ec on ec.id = e.category
             left join projects p on p.id = e.project
             left join expense_tax_category etc on etc.id = e.tax_category
             where e.id = ?
         ];
   my @data = $main->dbx_select(sql => $sql, values=>[$id]);
   
   $data[0]->{expense_dt} = UnixDate($data[0]->{expense_dt}, '%m/%d/%Y');
   $web->tplVars(data => $data[0],
                 cat_dd => $main->BuildDropdown({table => 'expense_category', fields => 'id, name', value => 'id', label => 'name', name => 'category', none=>'', match=>$data[0]->{category}}),
                 project_dd => $main->BuildDropdown({table => 'projects', fields => 'id, name', value => 'id', label => 'name', name => 'project', none=>'', match=>$data[0]->{project}}),
                 tax_dd => $main->MakeDropdown(table => 'expense_tax_category', fields => 'id, name', value => 'id', label => 'name', name => 'tax_category', none=>'', match=>$data[0]->{tax_category})
                 );

   my $file_sql = qq[select * from expense_attachment where expense_id = ? and deleted = 'N'];
   my @files = $main->dbx_select(sql => $file_sql, values=>[$id]);

   $web->tplVars(files => \@files);
   
   $web->setTpl('expense_edit.tpl');
}

sub del_fileAction
{
   my $id = $q->escapeHTML($q->param('id')) || '';
   my $fid = $q->escapeHTML($q->param('fid')) || '';
   my %data = ();
   $data{deleted} = 'Y';
   $main->dbx_save('expense_attachment', \%data, $fid);
   &editAction();
   $web->setTpl('expense_edit.tpl');
}

sub add_fileAction
{
   my $id = $q->escapeHTML($q->param('id')) || '';
   my $filename = $q->escapeHTML($q->param('filename'));
   if ($filename) {
      my $file = $main->SaveFile($path, $filename, 'filename');
      my %data = ();
      $data{expense_id} = $id;
      $data{filename} = $file;
      $data{file} = $filename;
      
      $main->dbx_save('expense_attachment', \%data);
   }
   &editAction();

   $web->setTpl('expense_edit.tpl');
}