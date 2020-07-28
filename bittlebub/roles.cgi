#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web_class = new add_user;

$web_class->dispatch();
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
   my $role_id = $web->getEscapedParam('role');
   $web->tplVars(
                 role_dd => $main->BuildDropdown({
                        table => 'roles',
                        fields => 'id, name',
                        value => 'id',
                        label => 'name',
                        name => 'role',
                        none => '',
                        onchange=>"$('#frm_filter').submit(); return false;",
                        match => $role_id
                     })
                );
   

   my $sql = qq[select rm.*, au.name as full_name, r.name as role_name
                  from role_members rm
                  left join admin_users au on au.uid = rm.uid
                  left join roles r on r.id = rm.role_id
               ];
   my @values = ();
   if ($role_id) {
      $sql .= qq[ where role_id = ?];
      push(@values, $role_id);
   }
   
   my @data = $main->dbx_select(sql => $sql, values => \@values);
   
   $web->tplVars(data => \@data);
   
   $web->setTpl('roles.tpl');
}

sub editAction
{
   $main->logit("editAction");
   
   my $id = $web->getEscapedParam('id');
   
   my @data = ();
   if ($id) {
      @data = $main->dbx_select(sql=>qq[select * from role_members where id = ?], values => [$id]);
   }
   
   $web->tplVars(data => $data[0],
                 role_dd => $main->BuildDropdown({
                        table => 'roles',
                        fields => 'id, name',
                        value => 'id',
                        label => 'name',
                        name => 'role',
                        none => '',
                        onchange=>"$('#frm_filter').submit(); return false;",
                        match => (@data) ? $data[0]->{role_id} : ''
                     }),
                 user_dd => $main->BuildDropdown({
                        table => 'admin_users',
                        fields => 'uid, name',
                        value => 'uid',
                        label => 'name',
                        name => 'user',
                        none => '',
                        onchange=>"$('#frm_filter').submit(); return false;",
                        match => (@data) ? $data[0]->{uid} : ''
                     })
         );
   $web->setTpl('roles_edit.tpl');
}

sub saveAction
{
$main->logit("saveAction");
   my %form = %{$web->getVars()};
   $form{role_id} = $form{role};
   $form{uid} = $form{user};
 
$main->logit("uid [$form{uid}]");
$main->logit("role [$form{role_id}]");
$main->logit("record id [$form{id}]");

   my $ret = $main->dbx_save('role_members', \%form, $form{id});
   
$main->logit("return value [$ret]");

   &defaultAction();
}