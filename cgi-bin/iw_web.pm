#!/usr/bin/perl -w 
##########################################################################################
#
# iw_web.pm
# Main web based routines
#
# Gordon Rhea
# Copyright 2008
#
##########################################################################################
    BEGIN {
    my $b__dir = (-d '/home2/itarswor/perl'?'/home2/itarswor/perl':( getpwuid($>) )[7].'/perl');
    unshift @INC,$b__dir.'5/lib/perl5',$b__dir.'5/lib/perl5/x86_64-linux-thread-multi',map { $b__dir . $_ } @INC;
    }
    
use CGI qw(:standard escapeHTML);
use CGI::Session;
use CGI::Cookie;
use DBI;
#use Data::Dumper;
#use Email::MIME;


package iw_web;

my %vars = ();
my $tfile = '';

sub new { 
    my $class = shift;
    my %args = @_;
    
    $Database = $args{database} if($args{database});
   open LOGFILE, ">>$Logfile";
   
    my $self = {
	Vars => \%vars,
        tFile => $tfile
    };
    bless $self, $class;
    return $self; 
}

sub getEscapedParam
{
   my $self = shift;
   my $parm = shift;
   
   my $q = new CGI;
   
   my $ret = $q->escapeHTML($q->param($parm)) || '';
   
   return $ret;
}

sub getVars
{
   my $self = shift;
   
   my $q = new CGI;
   my %vars = $q->Vars();
   
   foreach my $key (keys %vars) {
      $vars{$key} = $q->escapeHTML($vars{$key});
   }
   
   return \%vars;
}

sub setTpl
{
   my $self = shift;
   my $tpl = shift;
   
   $self->{tFile} = $tpl;
   
}

sub tplVars
{
    my $self = shift;
    my %args = @_;
    
    if (keys %args) {
	foreach my $key (keys %args) {
	    $vars{$key} = $args{$key};
	}
    } else {
	return \%vars;
    }
}

sub dispatch
{
   my $self = shift;
      
   $self->init($self);
 
   print "Content-Type: text/html\n\n";
  
   my $action = $self->getEscapedParam('a') || 'default';
#   $action =~ s/((?<=[a-z])[A-Z][a-z]+)/_\U$1/g;
#   $action =~ s/(\b[A-Z][a-z]+)/\U$1/g;

   my $sub = $action . "Action";
   
   $self->$sub($self);
   
   show_screen($self, $self->{tFile});
   return 1;
}

sub logit
{
   my ($self, $msg) = @_;
   
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

   $mon++;
   $year += 1900;
   open LOGFILE, ">>logfile.txt";
   
   print LOGFILE "$mon-$mday-$year $hour:$min:$sec - " . $msg . "\n";
   
   close LOGFILE;
}

sub show_screen()
{
   my $self = shift;
   my $tfile = shift;
   my $template = Template->new(INCLUDE_PATH => 'tpl/');

   $template->process($tfile, \%vars) || $self->logit("Template error [" . $template->error() . "]");
}

sub redirect
{
    my ($target) = @_;
    my $q = new CGI;
    
    $q->redirect($target);
}
1;