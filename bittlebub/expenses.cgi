#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;
use Date::Manip;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;
use iw_web;

my $q = new CGI;
my $main = new iw_admin(database => 'itarswor_production');
our $web = new iw_web;

my $dbh = $main->GetDBConnection();

our %vars = ();

my $session = $main->get_session();
if(!$session->param("uid"))
{
    print $q->redirect("login.cgi");
    exit;
}

if (!$session->param("rpp")) {
   $session->param("rpp", 25);
}

my $action = $q->escapeHTML($q->param('a') || '');

print "Content-type: text/html\n\n";

my $tablename = 'expenses';
my $tfile = 'expense.tpl';
#my $sth = $dbh->prepare($sql);
#$sth->execute();
my $path = 'files/expenses';

#my @data = $main->dbx_select(sql => $sql);

if ($action eq 'save') {
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
   
   $vars{msg} = $msg;
   &defaultAction();
} elsif ($action eq 'edit') {
   my $id = $q->escapeHTML($q->param('id')) || '';

      &editAction();
      $tfile = 'expense_edit.tpl';
} elsif($action eq 'add_file') {
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
   $tfile = 'expense_edit.tpl';
} elsif($action eq 'del_file') {
   &delFileAction();
   &editAction();
   $tfile = 'expense_edit.tpl';
} else {
   &defaultAction();
}

#$vars{menu} = $main->write_menu({menu_id => 'admin_menu', menu => 'admin', direction=> 'horizontal'});
$vars{menu} = $main->getMenu();

#$vars{msg} = 'this is a test';
show_screen($tfile);
exit;

sub show_screen()
{
   my $tfile = shift;
   my $template = Template->new(INCLUDE_PATH => 'tpl/');
   
#   $tfile = 'tpl/' . $tfile;
   $template->process($tfile, \%vars) || $main->logit("Template error [" . $template->error() . "]");
}

sub defaultAction
{
   my $start_dt = $q->escapeHTML($q->param("start_dt")) || '';
   my $end_dt = $q->escapeHTML($q->param("end_dt")) || '';
   my $category = $q->escapeHTML($q->param("category")) || '';
   my $rpp = $q->escapeHTML($q->param("rpp")) || $session->param("rpp");
   my $page = $q->escapeHTML($q->param("p")) || 1;
   
   my %form = %{$web->getVars()};
   
   if (!$rpp) { $rpp = 25; }
   
   my $count = 0;
   $vars{title} = 'Expense Report';
   $vars{site_name} = '';
   
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
   if ($category) {
      push(@where, qq[category = ?]);
      push(@values, $category);
   }
   
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
   $vars{'cat_dd'} = $main->MakeDropdown(table => 'expense_category', fields => 'id, name', value => 'id', label => 'name', name => 'search_category', none=>'', match=>$form{search_category});
   $vars{'project_dd'} = $main->MakeDropdown(table => 'projects', fields => 'id, name', value => 'id', label => 'name', name => 'search_project', none=>'', match=>$form{search_project});
   $vars{'tax_dd'} = $main->MakeDropdown(table => 'expense_tax_category', fields => 'id, name', value => 'id', label => 'name', name => 'search_tax_category', none=>'', match=>$form{search_tax_category});

   $vars{'rpp_dd'} = $main->MakeDropdown(static => ['10','25','50'], name=>"rpp", match=>$rpp);
   $vars{data} = \@data;
   $vars{start_dt} = $start_dt;
   $vars{end_dt} = $end_dt;
   
   $vars{page} = $page;
   $vars{max_page} = $max_page;
   
   $session->param("rpp",$rpp);
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
   $vars{data} = $data[0];
   $vars{'cat_dd'} = $main->BuildDropdown({table => 'expense_category', fields => 'id, name', value => 'id', label => 'name', name => 'category', none=>'', match=>$data[0]->{category}});
   $vars{'project_dd'} = $main->BuildDropdown({table => 'projects', fields => 'id, name', value => 'id', label => 'name', name => 'project', none=>'', match=>$data[0]->{project}});
   $vars{'tax_dd'} = $main->MakeDropdown(table => 'expense_tax_category', fields => 'id, name', value => 'id', label => 'name', name => 'tax_category', none=>'', match=>$data[0]->{tax_category});

   my $file_sql = qq[select * from expense_attachment where expense_id = ? and deleted = 'N'];
   my @files = $main->dbx_select(sql => $file_sql, values=>[$id]);

   $vars{files} = \@files;
   
}

sub delFileAction
{
   my $id = $q->escapeHTML($q->param('id')) || '';
   my $fid = $q->escapeHTML($q->param('fid')) || '';
   my %data = ();
   $data{deleted} = 'Y';
   $main->dbx_save('expense_attachment', \%data, $fid);
}