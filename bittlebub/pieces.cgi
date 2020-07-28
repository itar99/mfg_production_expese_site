#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use Template;
use JSON;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $web = new pieces;

$web->dispatch();
exit;

package pieces;

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
   my $sql = qq[select * from pieces ];
   my @data = $main->dbx_select(sql=>$sql);
   
   $web->tplVars(data => \@data,
                 title => 'Pieces List'
                 );
   $web->setTpl('pieces.tpl');
}

sub detailAction
{
   my $id = $web->getEscapedParam('id');

   my @data = ();
#   if ($id) {
      my $sql = qq[select * from pieces where id = ?];
      @data = $main->dbx_select(sql=>$sql, values=>[$id]);
#   }

   my $files_sql = qq[select * from attachments where codeset = 'pieces' and reference_id = ? and deleted = 'N'];
   my @files = $main->dbx_select(sql => $files_sql, values=>[$id]);
   
   my $molds_sql = qq[select m.id, m.name, mt.name as type, pm.id as link_id
                     from pieces_to_molds pm 
                     left join molds m on m.id = pm.mold_id
                     left join mold_type mt on mt.id = m.type
                     where pm.piece_id = ?
                     ];
   my @molds = $main->dbx_select(sql => $molds_sql, values => [$id]);
   
   $web->tplVars(d => $data[0],
                 attachments => \@files,
                 title => 'Piece Detail',
                 molds => \@molds
               );
   $web->setTpl('pieces_detail.tpl')
}

sub editAction
{
   my $id = $web->getEscapedParam('id');
   
   my @data = ();
   
   my $title = '';
   if ($id) {
      $title = 'Edit Piece';
      my $sql = qq[select * from pieces where id = ?];
      @data = $main->dbx_select(sql=>$sql, values=>[$id]);
   } else {
      $title = 'Add Piece';
   }
   
   $web->tplVars(title => $title,
                 data => $data[0]
                 );
   
   $web->setTpl('pieces_edit.tpl');
}

sub saveAction
{
   my %form = $web->getVars;

   my $id = $main->dbx_save('pieces', \%form, $form{id});

   $q->param(id => $id);
   
   &detailAction();
}

sub saveAttachmentAction
{
   my $filename = $q->param('filename');
   my $id = $web->getEscapedParam('id');
   my $path = 'files/pieces';
   
   my $file = $main->SaveFile($path, $filename, 'filename');
   
   my %attachment = ();
   $attachment{reference_id} = $id;
   $attachment{upload_dt} = $main->get_datetime();
   $attachment{filename} = $filename;
   $attachment{file} = $file;
   $attachment{codeset} = 'pieces';
   
   $main->dbx_save('attachments', \%attachment);
   
   &detailAction();
}

sub deleteAttachmentAction
{
   my $aid = $web->getEscapedParam('aid');
   
   my %data = ();
   $data{deleted} = 'Y';
   $main->dbx_save('attachments', \%data, $aid);
      
   &detailAction();
}

sub addMoldAction
{
   my $id = $web->getEscapedParam('id') || '';
   my $mid = $web->getEscapedParam('mid');
   
$main->logit("addMoldAction id[$id] mid [$mid]");
   my %rec = (
         piece_id => $id,
         mold_id => $mid
      );
   
   $main->dbx_save('pieces_to_molds', \%rec);
   &detailAction();
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

sub deleteMoldLinkAction
{
   my $id = $web->getEscapedParam('mid') || '';
   
   $main->dbx_delete(tablename => 'pieces_to_molds', where => qq[id = ?], values => [$id]);
   
   &detailAction();
}