#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;
use JSON;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web = new molds;

$web->dispatch();
exit;

package molds;

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
   my $sql = qq[select * from molds ];
   my @data = $main->dbx_select(sql=>$sql);
   
   my @columns = (
         {
            name => 'Name',
            column => 'name'
         },
         {
            name => 'Type',
            column => 'type'
         },
         {
            name => 'Material',
            column => 'material'
         },
         {
            name => 'Pieces',
            column => 'pieces_count'
         },
         {
            name => 'Status',
            column => 'status'
         },
      );
   

   $web->tplVars(data => \@data,
                 columns => \@columns,
                 title => 'Mold List'
                 );
   $web->setTpl('list.tpl');

}

sub editAction
{
   my $id = $web->getEscapedParam('id');
   
   my $sql = qq[select * from molds where id = ?];
   my @data = $main->dbx_select(sql => $sql, values=>[$id]);
   
   my $item = $data[0];
   $web->tplVars(data => $item,
                 type_dd => $main->BuildDropdown({table=>'mold_type',
                                                 fields => 'id,name',
                                                 name => 'type',
                                                 value => 'id',
                                                 label => 'name',
                                                 none => '',
                                                 match => $item->{type}
                                                }),
                 status_dd => $main->BuildDropdown({table=>'mold_status',
                                                 fields => 'id,name',
                                                 name => 'status',
                                                 value => 'id',
                                                 label => 'name',
                                                 none => '',
                                                 match => $item->{status}
                                                }),
                 title => 'Molds'
                 );
   
   $web->setTpl('mold_edit.tpl');
}

sub saveAction
{
   my %form = %{$web->getVars()};
   
   $main->dbx_save('molds', \%form, $form{id});
   
   &defaultAction();
}

sub searchMoldsAction
{
    my @data = ();
    
    my $text = $q->param('text');
    my $term = $q->param('term');
    
    my $sql = '';
    my @values = ();
    $sql = qq[select * from molds where name like ?];
    push(@values, "%$text%");

    
    my @data = $main->dbx_select(sql => $sql, values => \@values);
    
    print JSON::to_json(\@data);
    exit;
}