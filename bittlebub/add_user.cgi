#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web = new add_user;

$web->dispatch();
exit;

package add_user;
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

#   my $menu = $main->write_menu({menu_id => 'admin_menu', menu => 'admin', direction=> 'horizontal'});
   my $menu = $main->getMenu();

   $web->tplVars(menu => $menu);
}

sub defaultAction
{
   my $self = shift;
   $main->logit("defaultAction run");
   
   my $sql = qq[select * from admin_users ];
   my @data = $main->dbx_select(sql=>$sql);
   
   $web->tplVars(data => \@data);
   $web->setTpl('add_user.tpl');
}

sub editAction
{
   my $id = $web->getEscapedParam('id');
   
$main->logit("editAction id [$id]");
   my @data = $main->dbx_select(sql => qq[select * from admin_users where id = ?], values => [$id]);
   
   $web->tplVars(data => $data[0]);
   $web->setTpl('add_user_edit.tpl');
}

sub saveAction
{
   my %form = %{$web->getVars()};
   
   my $dbh = $main->GetDBConnection();
   
   if ($form{active}) {
      $form{active} = 'Y';
   } else {
      $form{active} = 'N';
   }
   
   $form{encrypt}{password}{key} = 'IWS_ADMIN13#';

   my $id = $main->dbx_save('admin_users', \%form, $form{id});
   
   my $msg = '';
   
   if ($id) {
      $msg = qq[Your record was saved.];
   } else {
      $msg = qq[There was a problem saving your record.];
   }
   $web->tplVars('msg' => $msg);
   &defaultAction;
}