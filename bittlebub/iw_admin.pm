#!/usr/bin/perl -w 
##########################################################################################
#
# iw_admin.pm
# main admin package.  inherits iw_main
#
# Gordon Rhea
# Copyright 2015
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
use Data::Dumper;
#use Email::MIME;


package iw_admin;
use lib "/home2/itarswor/public_html/cgi-bin";
use parent ('iw_main');

sub getMenu
{
   my $self = shift;
   my $main = $self->write_menu(menu_id => 'admin_menu', menu => 'admin', direction=> 'horizontal');
#$self->logit("menu [$main]");
   return $main;
}

sub write_menu
{
#    my ($self, $args) = @_;
    my $self = shift;
    my %args = @_;
    
    return if(!$args{menu});
    
#foreach my $key (keys %args) {
#    $self->logit("menu key [$key] value [$args{$key}]");
#}
    $args{menu_id} = 'menu' if(!defined($args{menu_id}));
    
    my $dbh = $self->GetDBConnection();
    
    my $menu_sql = qq[select * from menus where menu_name = ? and master_id = 0 order by sort];
    my $menu_sth = $dbh->prepare($menu_sql);
    $menu_sth->execute($args{menu});
    
    my $output = '';
    my $class = '';
    if ($args{direction} eq 'horizontal') {
	$class = 'nav'
    } elsif ($args{direction} eq 'vertical') {
	$output .= '<script>
	    $(function(){
	    $(\'#' . $args{menu_id} . '\').menu();
	    });
	    </script>';
    }
    
    $class .= " $args{class}";
    
    my $session = $self->get_session();
    
    $output .= qq[\n<ul id="$args{menu_id}" class="$class" style="$args{style}">\n];
    
    while (my $master = $menu_sth->fetchrow_hashref()){
        next if($master->{role} && !$self->user_has_access($session->param('uid'), $master->{role}, $session->param('level')));
        
	$output .= qq[<li>];
        if($master->{url}) {$output .= qq[<a href="$master->{url}">]; }
        $output .= qq[$master->{text}&nbsp;];
        if($master->{url}) {$output .= qq[</a>]; }
	$output .= $self->get_menu_items($master->{id});
	$output .= qq[</li>\n];
    }
    
    $output .= "</ul>\n";
}

sub get_menu_items
{
    my ($self, $master_id) = @_;
    
    my $output = '';
    
    my $dbh = $self->GetDBConnection();
    my $sql = qq[select * from menus where master_id = ? order by sort];

    my $sth = $dbh->prepare($sql);
    $sth->execute($master_id);
    
    my $session = $self->get_session();
    
    $output .= qq[<ul>];
    while (my $item = $sth->fetchrow_hashref()) {
      next if($item->{role} && !$self->user_has_access($session->param('uid'), $item->{role}, $session->param('level')));
	$output .= qq[<li><a href="$item->{url}">$item->{text}</a>\n];
#        if($item->{url}) {$output .= qq[<a href="$item->{url}">]; }
#        $output .= qq[$item->{text}&nbsp;];
#        if($item->{url}) {$output .= qq[</a>]; }

	my $sub = $self->get_menu_items($item->{id});
	if ($sub) {
	    $output .= qq[$sub\n];
	}
	
	$output .= qq[</li>\n];
    }
    $output .= qq[</ul>];
    return $output;
}

sub user_has_access
{
   my $self = shift;
   my $uid = shift;
   my $role = shift;
   my $level = shift;
   
   my $session = $self->get_session();

   if ($level && $level == 0) {
      return 1;
   }
   
   my $sql = qq[select * from role_members rm left join roles r on r.id = rm.role_id and r.name = ? where rm.uid = ? and rm.active = 1];
   my @data = $self->dbx_select(sql => $sql, values => [$role, $uid]);
   
   return @data;
}
1;