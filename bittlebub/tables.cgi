#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web_class = new table_edit;

$web_class->dispatch();
exit;

package table_edit;
use parent('iw_web');

our $main = '';
our $web = '';
our $q = '';

sub init
{
   my $self = shift;
   $web = $self;
   $q = new CGI;
   
   $main = new iw_admin(database => 'itarswor_production');
   $main->logit("init");
   
   my $session = $main->get_session();
   if(!$session->param("uid"))
   {
       print $q->redirect("login.cgi");
       exit;
   }

   my $menu = $main->getMenu();

   $web->tplVars(menu => $menu);
}

sub defaultAction
{
   $main->logit("tables.cgi defaultAction");
   my $tid = $web->getEscapedParam("tid");
   
   my $load_sql = qq[select * from table_edit where id = ?];
   my @table = $main->dbx_select(sql=>$load_sql, values=>[$tid]);
   
   our $tablename = $table[0]->{name};
   our $load_event = '';
   
   my $sql = qq[show columns from $tablename];
  # my $col_sth = $dbh->prepare($sql);
   
   my @cols = (); 
   my @col_data = $main->dbx_select(sql => $sql);
#   $col_sth->execute();
   
   foreach my $col (@col_data) {
#   while (my $col = $col_sth->fetchrow_hashref()) {
   #    print Dumper($col);
       next if($col->{Field} eq 'entered_uid');
       next if($col->{Field} eq 'entered_dt');
       next if($col->{Field} eq 'updated_uid');
       next if($col->{Field} eq 'updated_dt');
       push(@cols, $col->{Field});
   }

   my @data = $main->dbx_select(sql=>qq[select * from $tablename]);
   
   $web->tplVars(
            title => "Show Table $tablename",
            cols => \@cols,
            data => \@data,
            tid => $tid
         );
   $web->setTpl('tables.tpl');
}

sub editAction
{
   my $tid = $web->getEscapedParam("tid");
   my $id = $web->getEscapeParam('id');
   
   
}

sub buildEdit
{
   my $sql = qq[show columns from $tablename];
   
}

sub build_input_type
{
    my %type = ();
    
    $type{varchar} = {type => "text"};
    $type{text} = {type => "textarea"};
    $type{int} = {type => "text"};
    $type{date} = {type => "text"};
    $type{bit} = {type => "checkbox"};
    
    return \%type;
}
