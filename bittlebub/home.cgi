#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $q = new CGI;
my $main = new iw_admin(database => 'itarswor_production');

my $dbh = $main->GetDBConnection();

our %vars = ();

my $session = $main->get_session();
#$main->logit("session [" . Dumper($session) . "]");
$main->logit("home.cgi");
$main->logit("uid [" . $session->param("uid") . "]");
$main->logit("home session hash [" . Dumper($session->dataref) . "]");

if(!$session->param("uid"))
{
    print $q->redirect("login.cgi");
    exit;
}

print "Content-type: text/html\n\n";
$vars{menu} = $main->write_menu(menu_id => 'admin_menu', menu => 'admin', direction=> 'horizontal');
$vars{title} = 'Itar\'s Workshop Internal site';

show_screen('home.tpl');
exit;

sub show_screen()
{
   my $tfile = shift;
   my $template = Template->new(INCLUDE_PATH => 'tpl/');
   
#   $tfile = 'tpl/' . $tfile;
   $template->process($tfile, \%vars) || $main->logit("Template error [" . $template->error() . "]");
}