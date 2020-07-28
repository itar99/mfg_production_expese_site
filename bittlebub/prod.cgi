#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web = new prod;

$web->dispatch();
exit;

package prod;

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
   $web->setTpl('add_prod.tpl');
}
