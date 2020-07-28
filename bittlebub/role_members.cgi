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

   my $menu = $main->getMenu();

   $web->tplVars(menu => $menu);
}

sub defaultAction
{
   $web->tplVars(
                 role_dd => $main->BuildDropdown(table => 'roles', fields => 'id, name', value => 'id', label => 'name', name => 'category')
                );
   
   my $role_id = $web->getEscapedParam('role');
   my $sql = qq[select * from role_members where role_id = ?];
   
   $web->setTpl('roles.tpl');
}