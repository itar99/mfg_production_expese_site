#!/usr/bin/perl -w 
##########################################################################################
#
# iw_main.pm
# main object that is inherited by various scripts
# this package contains generic routines that can be used across various scripts
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
use Data::Dumper::Names;
use Date::Manip;
#use Email::MIME;


package iw_main;

# Update the following values to be able to connect to the database
my $ConnectString = "dbi:mysql:database=itarswor_joom;host=localhost;port=3306";
my $Database = 'itarswor_joom';
my $Db_port = '3306';
my $LoginId = "itarswor_web";
my $Password = "FedjfcbmqwG5q4W";
my $Logfile = "logfile.txt";

##########################################################################################
#
# You shouldn't have to update anything below to get this to work
#
##########################################################################################
sub new { 
    my $class = shift;
    my %args = @_;
    
    $Database = $args{database} if($args{database});
   open LOGFILE, ">>$Logfile";
   
    my $self = {
	_ConnectionString => $ConnectString,
	_LoginId => $LoginId,
	_Password => $Password,
	_Logfile => $Logfile,
	_Database => $Database,
	_Db_port => $Db_port
    };
    bless $self, $class;
    return $self; 
}

sub WriteHeader {
    my ($title) = @_;
    # writes the main menu and all the stuff at the top of the page
    #$HEADER = "../header.html";
    print "<!DOCTYPE html>";
 #   print qq[<script type="text/javascript" src="http://www.itarsworkshop.com/js/jquery-1.8.2.js">\n];
 #   print qq[<script type="text/javascript" src="http://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.min.js">\n];
 #   print qq[<script type="text/javascript" src="http://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.js">\n];
    if(-e "header.html")
    {
	open HEADER, "< header.html";
	while(<HEADER>)
	{
	    #chop;
	    print $_;
	}
    }
    else
    {
       print"<HEAD><TITLE>$title</TITLE></HEAD>\n";
    }
}

sub WriteFooter {
    # writes the bottom of the page
    $FOOTER = "../footer.html";
    open FOOTER;
    while(<FOOTER>)
    {
	#chop;
	print $_;
    }
}

sub RunSQL {
    my $self = shift;
    my ( $sql ) = @_;
    print "sql - $sql";
    chop $sql;
    my $dbh = $self->GetDBConnection();

    my $sth = $dbh->prepare("$sql") or print "unable to prepare statement $DBI::errstr.<br>";
    $sth->execute or print "error executing sql $DBI::errstr<br>";
    return $sth;
}

sub get_table_columns {
   my $self = shift;
   my $tablename = shift;
   my $dbh = $self->GetDBConnection();
   
    my $sql = qq[show columns from $tablename];
    my $col_sth = $dbh->prepare($sql);
    
    my @cols = ();
    $col_sth->execute();

    my %columns = ();
    while (my $col = $col_sth->fetchrow_hashref()) {
	$columns{$col->{Field}} = $col;
    }
    
    return \%columns;
}

sub dbx_save {
    my $self = shift;
    my $tablename = shift;
    my $args = shift;
    my $id = shift;

    $args->{id} = undef; # wipe the id of the record so we don't try to overwrite it later
    if (!$tablename) {
	# no table to save to.  exit
	return undef;
    }
    
    my %fields = ();
    my @values = ();
    my $columns = $self->get_table_columns($tablename);

    foreach my $key (keys %{$args}) {
	next if(!defined($columns->{$key})); # don't try to save if the column isn't in the table.
	next if($key eq 'updated_uid');
	next if($key eq 'updated_dt');
	next if($key eq 'entered_uid');
	next if($key eq 'entered_dt');
	$fields{$key} = $args->{$key};
    }
    
    if ($columns->{'entered_uid'} && $columns->{'entered_dt'}) {
	$fields{'entered_uid'} = '';
	$fields{'entered_dt'} = '';
    }
    
    if ($columns->{'updated_uid'} && $columns->{'updated_dt'}) {
	$fields{'updated_uid'} = '';
	$fields{'updated_dt'} = '';
    }
    my $sql = '';
    
    if ($id) {
	# we have an id specified.  update the existing record
	$sql = qq[update $tablename set ];
	foreach my $field (keys %fields) {
	    next if($field eq 'id');
# 	    next if(!$fields{$field});
	    if (defined($args->{encrypt}{$field})) {
		$sql .= qq[$field = aes_encrypt(?, '$args->{encrypt}{$field}{key}'),];
	    } else {
		if ($columns->{$field}{Type} eq 'date') {
		    my $format = "%m-%d-%Y";
		    if ($fields{$field} =~ /\//) {
			$format ="%m/%d/%Y";
		    }
		    
		    $sql .= qq[$field = STR_TO_DATE(?, '$format'),];
		} else {
		    $sql .= qq[$field = ?,];
		}
	    }
	    push(@values, $fields{$field});
	} 
	chop $sql; # remove the trailing comma
	if (defined($columns->{updated_uid}) && $columns->{updated_dt}) {
	    my $uid = '';
	    my $session = $self->get_session();
	    $uid = $session->param("uid") || '';
	    if ($uid) {
		$sql .= ", updated_uid = '$uid'";
		$sql .= ", updated_dt = now()";
	    }
	}
	
	$sql .= qq[ where id = ?];
	push(@values, $id);
    } else {
	# it's a new record
	$sql = qq[insert into $tablename (];
	my $placeholders = '';
	foreach my $field (keys %fields) {
	    next if(!$fields{$field});
	    next if($field eq 'id');
	    $sql .= qq[$field,];
#	    $placeholders .= '?,';
		if ($columns->{$field}{Type} eq 'date') {
		    my $format = "%m-%d-%Y";
		    if ($fields{$field} =~ /\//) {
			$format ="%m/%d/%Y";
		    }
		    
		    $placeholders .= qq[STR_TO_DATE(?, '$format'),];
		} else {
		    $placeholders .= qq[?,];
		}

	    push(@values, $fields{$field});
	}
	chop $sql; # remove the trailing comma
	chop $placeholders;
	
	if (defined($columns->{entered_uid}) && $columns->{entered_dt}) {
	    my $uid = '';
	    my $session = $self->get_session();
	    $uid = $session->param("uid") || '';
	    if ($uid) {
		$sql .= ",entered_uid";
		$sql .= ",entered_dt";
		$placeholders .= ", '$uid', now()";
	    }
	}
	
	$sql .= qq[) VALUES($placeholders)];
	$id = 0;
    }
    
    my $dbh = $self->GetDBConnection();
    my $sth = $dbh->prepare($sql);
    $sth->execute(@values);
    if ($sth->err) {
	$self->logit("dbx_save sql [$sql]");
	$self->logit($sth->errstr);
	$id = undef;
    }
    if (!$id) {
	$id = $sth->{mysql_insertid};
    }

    return $id;
}

sub dbx_select
{
    my $self = shift;
    my %args = @_;
    
    my $sql = $args{sql};
    my @values = @{$args{values}};
    my $debug = $args{debug};

    if($debug) {    
	$self->logit("sql [$sql]");
	foreach my $key (keys %args) {
	    $self->logit("$key - [$args{$key}]");
	}
    }
    if (!$sql) {
	$self->logit("dbx_select no sql specified");
	return undef;
    }
    
    my $dbh = $self->GetDBConnection();
    my $sth = $dbh->prepare($sql);
    
    if ($debug) {
	$self->logit("dbx_select sql [$sql]");
	foreach my $v (@values) {
	    $self->logit("value [$v]");
	}
    }
    
    $sth->execute(@values);
    
    if ($sth->err) {
	$self->logit("sql [$sql]");
	$self->logit($sth->errstr);
    }
    
    my @data = ();
    
    while (my $row = $sth->fetchrow_hashref()) {
#$self->logit("id [$id]");
	push(@data, $row);
    }
    
    if ($debug) {
	$self->logit("dbx_select rows found [" . @data . "]");
    }
    return @data;
}

sub dbx_delete
{
    my $self = shift;
    my %args = @_;

    if (!$args{tablename}) {
	$self->logit("dbx_delete no table specified");
	return;
    }
    
    if (!$args{where}) {
	$self->logit("dbx_delete no where clause specified!");
	return;
    }
    
    my @values = @{$args{values}};
    
    if ($args{where} !~ /^where/) {
	$args{where} = "WHERE " . $args{where};
    }
    
    my $sql = qq[delete from $args{tablename} $args{where}];
    
    my $dbh = $self->GetDBConnection();
    my $sth = $dbh->prepare($sql);
    
    if ($debug) {
	$self->logit("dbx_delete sql [$sql]");
    }
    
    $sth->execute(@values);
    
    if ($sth->err) {
	$self->logit("sql [$sql]");
	$self->logit($sth->errstr);
    }

}

sub SaveFile {
   my $self = shift;
   my ($upload_dir, $filename, $parmname) = @_;

   my $make_unique = 1;
   
   $filename=~s/.*[\/\\](.*)/$1/;
   $filename =~ s/\s+/_/g;
   
   my $output_file = "$upload_dir/$filename";
   if ($make_unique && -e $output_file) {
      my $count = 1;
      while (-e $output_file) {
        my @file = split(/\./, $filename);
	my $max = $#file;
	my $name = $file[$max - 1];
	$name .= "_$count";
	
	$file[$max -1] = $name;
	$f = join(".", @file);
	$output_file = "$upload_dir/$f";
        $count++;
      } 
   }
   
   my $q = CGI::new();
   my $tmp_file = $q->upload($parmname);
   open UPLOADFILE, ">$output_file";

   binmode UPLOADFILE;

   while ( <$tmp_file> )
   {
      print UPLOADFILE $_;
   }

   close UPLOADFILE;
   
   return "$output_file";
}

sub GetDBConnectString
{
   (my $self) = @_;
   return $self->{_ConnectionString};
}

sub GetDBLoginId
{
   (my $self) = @_;
   return $self->{_LoginId};
}

sub GetDBPassword
{
   (my $self) = @_;
   return $self->{_Password};
}

sub GetDBConnection
{
   my $self = shift;
   my @args = @_;

#   use Devel::StackTrace;
#my $trace = Devel::StackTrace->new;

#   my $con = $self->{_ConnectionString};
   my $db = $args{database};
   if(!$db) {
    $db = $self->{_Database};
   }
   
   my $port = $args->{port} || $self->{_Db_port};
   my $con = qq[dbi:mysql:database=$db;host=localhost;port=$port];
   my $login = $self->{_LoginId};
   my $pw = $self->{_Password};
   my $dbh = DBI->connect_cached($con, $login, $pw);
   if ($DBI::err) {
    $self->logit("there was an error connecting to the database: " + $DBI::errstr);
   }
   
   return $dbh;
}

sub PrepareSQL
{
   my ($sql) = @_;
   
   return if(!$sql);
   
}

sub BuildDropdown
{
    my $self = shift;
#    my $args = shift;
    my ($args) = @_;
   
    my $sql = '';
    my $table = '';
    my $fields = '*';
    my $where = '';
    my $name = '';
    my $id = '';
    my $value = '';
    my $label = '';
    my $match = '';
    my $output = '';
    my $none = '';
    my $onclick = '';
    
    if($args->{sql}) { $sql = $args->{sql}; }
    
    if($args->{table}) { $table = $args->{table}; }
    if($args->{fields}) { $fields = $args->{fields}; }
    if($args->{where}) { $where = $args->{where}; }
    if($args->{name}) { $name = $args->{name}; }
    if($args->{id}) { $id = $args->{id}; }
    if($args->{value}) { $value = $args->{value}; }
    if($args->{label}) { $label = $args->{label}; }
    if($args->{match}) { $match = $args->{match}; }
    if(defined($args->{none})) { $none = ($args->{none} && $args->{none} != 1) ? $args->{none} : 'None Selected'; }
    if ($args->{onchange}) { $onclick = $args->{onchange}; }
    
    if (!$id) {
	$id = $name;
    }
    
    if(!$sql)
    {
	$sql = qq[select $fields from $table $where];
    }
    
    if(!$id) { $id = $name; }
    if(!$label) { $label = $value; }
    
    my $dbh = GetDBConnection($self);
    my $sth = $dbh->prepare($sql);
    
    $sth->execute();
    if ($sth->err) {
	$self->logit("BuildDropDown sql [$sql]");
	$self->logit($sth->errstr);
    }

    $output .= qq[<select name="$name" id="$id">\n];
    if ($onchange){
	$output .= qq[onchange="$onchange" ];
    }
    
    $output .= ">\n";
    if ($none) {
	$output .= qq[<option value="">$none</option>\n];
    }
    
    while(my $row = $sth->fetchrow_hashref())
    {
	$output .= qq[<option value="$row->{$value}"];
	if($match eq $row->{$value})
	{
	    $output .= qq[ selected ];
	}
	$output .= qq[>$row->{$label}</option>\n];
    }
    $output .= qq[</select>\n];
    return $output;
}

sub MakeDropdown
{
    my $self = shift;
#    my $args = shift;
    my %args = @_;
   
    my $sql = '';
    my $table = '';
    my $fields = '*';
    my $where = '';
    my $name = '';
    my $id = '';
    my $value = '';
    my $label = '';
    my $match = '';
    my $output = '';
    my $none = '';
    my $onclick = '';
    my @values = ();
    my @static = ();
    my @static_values = ();
    
    if($args{sql}) { $sql = $args{sql}; }
    
    if($args{table}) { $table = $args{table}; }
    if($args{fields}) { $fields = $args{fields}; }
    if($args{where}) { $where = $args{where}; }
    if($args{name}) { $name = $args{name}; }
    if($args{id}) { $id = $args{id}; }
    if($args{value}) { $value = $args{value}; } else { $value = 'value'; }
    if($args{label}) { $label = $args{label}; } else { $label = 'label'; }
    if($args{match}) { $match = $args{match}; }
    if(defined($args{none})) { $none = ($args{none} && $args{none} != 1) ? $args{none} : 'None Selected'; }
    if ($args{onchange}) { $onclick = $args{onchange}; }
    if ($args{values}) { @values = @{$args{values}}; }
    if ($args{static}) { @static = @{$args{static}}; }
    if ($args{static_values}) { @static_values = @{$args{static_values}}; } else { @static_values = @{$args{static}}; }
    
    
    if (!$id) {
	$id = $name;
    }
    
    if(!$sql)
    {
	$sql = qq[select $fields from $table $where];
    }
    
    if(!$id) { $id = $name; }
    if(!$label) { $label = $value; }
    
    my @data = ();
    
    if (@static) {
	for (my $i = 0; $i < @static; $i++) {
	    my %rec = ();
	    $rec{label} = $static[$i];
	    my $val = ($static_values[$i]) ? $static_values[$i] : $static[$i];
	    $val = $static_values[$i];
	    if (!$val) {
		$val = $static[$i];
	    }
	    
	    $rec{value} = $val;
	    push(@data, \%rec);
	}
    } else {
	@data = $self->dbx_select(sql => $sql, values => \@values);
    }
    
    $output .= qq[<select name="$name" id="$id">\n];
    if ($onchange){
	$output .= qq[onchange="$onchange" ];
    }
    
    $output .= ">\n";
    if ($none) {
	$output .= qq[<option value="">$none</option>\n];
    }
    
    foreach my $row (@data)
    {
	$output .= qq[<option value="$row->{$value}"];
	if($match eq $row->{$value})
	{
	    $output .= qq[ selected ];
	}
	$output .= qq[>$row->{$label}</option>\n];
    }
    $output .= qq[</select>\n];
    return $output;
}

sub logit
{
   my ($self, $msg) = @_;
   
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

   $mon++;
   $year += 1900;
   open LOGFILE, ">>$self->{_Logfile}";
   
   print LOGFILE "$mon-$mday-$year $hour:$min:$sec - " . $msg . "\n";
   
   close LOGFILE;
}

sub get_session
{
   my ($ses_name, $timeout) = @_;
   
   my $name;
   if (!$timeout || length($timeout) == 0) {
     $timeout = '+4h';
   }
   
   $name = 'IWSSESS';

   my $cgi = new CGI;
   
   my $sid = $cgi->cookie($name); # || $cgi->param('sid') || undef;

   my $session = CGI::Session->load($sid);

   $session = $session->new($sid) or die "cannot create session: " . $session->errstr();
 
   if(!$sid)
   { 
      my $cookie = CGI::Cookie->new(-name => $name, -value => $session->id);

      print "Set-Cookie: $cookie\n";
   }
#   $session->expire($timeout);
   
   return $session;
}

sub is_admin
{
    my $self = shift;
   my $session = $self->get_session();
   if ($session->{admin}) {
    return 1;
   }
   
   return 0;
}
#logout the session
sub logout
{
    my $session = get_session();
    my $name = 'IWSSESS';
#    $session->delete();
#    $session->flush();
    my $cgi = new CGI;
    my $cookie = $cgi->cookie($name => '');
#    print $cgi->header(-cookie => $cookie);
    print "Set-Cookie: $cookie\n";
    
    $session->delete();
}
sub redirect
{
    my $target = shift;
    
    #print qq[Location: $target\n\n];
}

sub send_email
{
   my ($self, $args) = @_;
   #my %args = %{$values};
   
#   open LOGFILE, ">>logfile.txt";
   
#   foreach my $key (keys %{$args})
#   {
#	print LOGFILE "key [$key] value [$args->{$key}]\n";
#   }
#   print LOGFILE "to [$args->{to}]\n";
#   print LOGFILE "dumper [" . Dumper(\%values) . "]\n";
   
   close LOGFILE;

   my $type = "Content-type: text/plain\n\n";
   
   if($args->{html})
   {
	$type = "Content-type: text/html\n\n"
   }
   
   my $mailprog = '/usr/sbin/sendmail -i -t';
   open(MAIL, "|$mailprog") or die "cannot open send mail";
   print MAIL "To: $args->{to}\n";
   print MAIL "FROM: $args->{from} ($args->{name})\n";
   print MAIL "SUBJECT: $args->{subject}\n";
   print MAIL $type;
   print MAIL "$args->{message}\n";
   close(MAIL);

}

sub generate_random_string
{
   my ($self, $size) = @_;
   if(!defined($size) || !$size)
   {
       $size = 8;
   }
   
    my @chars = ("A".."Z", "a".."z");
    my $string;
    
    for(my $i=0; $i<$size; $i++)
    {
	$string .= $chars[rand @chars];
    }
    #$string .= $chars[rand @chars] for 1..$size;

    return $string;
}

sub write_admin_menu
{
    my ($self) = @_;
    # write the menu

    print <<EOF;
    <div style="margin-left: auto;margin-right: auto;">
    <table style="width:100%">
    <tr><td style="text-align:center;"><a href="customers.cgi">Customer List</a></td>
       <td style="text-align:center;"><a href="product_report.cgi">Product Report</a></td>
       <td style="text-align:center;"><a href="orders.cgi">Orders</a></td>
       <td style="text-align:center;"><a href="order_list.cgi">Order List</a></td>
       <td style="text-align:center;"><a href="login.cgi?a=logout">Logout</a></td>
    </tr>
    </table>
    </div>
EOF
}

sub write_menu
{
#    my ($self, $args) = @_;
    my $self = shift;
    my %args = @_;
    
    return if(!$args{menu});
    
    $args{menu_id} = 'menu' if(!defined($args{menu_id}));
    
    my $dbh = $self->GetDBConnection();
    
    my $menu_sql = qq[select * from menus where menu_name = ? and master_id = 0 order by sort];

#    my $menu_sth = $dbh->prepare($menu_sql);
#    $menu_sth->execute($args{menu});
    my @menu = ();
    if ($args{static_data}) {
	@menu = @{$args{static_data}};
    } else {
	@menu = $self->dbx_select(sql => $menu_sql, values => [$args{menu}]);
    }
    
    my $output = '';
    my $class = '';
    if ($args{direction} eq 'horizontal') {
	$class = 'nav'
    } elsif ($args{direction} eq 'vertical') {
#	$class = 'vert_menu';
	$output .= '<script>
	    $(function(){
	    $(\'#' . $args{menu_id} . '\').menu();
	    });
	    </script>';

    }
    
    $class .= " $args{class}";
    
#    my $child_sql = qq[select * from menus where master_id = ?];
#    my $child_sth = $dbh->prepare($child_sql);
    
   $output .= qq[\n<ul id="$args{menu_id}" class="$class" style="$args{style}">\n];
    
#    while (my $master = $menu_sth->fetchrow_hashref()){
    foreach my $master (@menu) {
#$self->logit("text [$master->{test}]");
	$output .= qq[<li><a href="$master->{url}">$master->{text}</a>];
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
    my $sql = qq[select * from menus where master_id = ?];

    my $sth = $dbh->prepare($sql);
    $sth->execute($master_id);
    $output .= qq[<ul>];
    while (my $item = $sth->fetchrow_hashref()) {
	$output .= qq[<li><a href="$item->{url}">$item->{text}</a>\n];
	my $sub = $self->get_menu_items($item->{id});
	if ($sub) {
	    $output .= qq[$sub\n];
	}
	
	$output .= qq[</li>\n];
    }
    $output .= qq[</ul>];
    return $output;
}

sub get_datetime
{
   return Date::Manip::UnixDate('now', '%Y-%d-%m %H:%M:%S %p');    
}

sub format_datetime
{
    my $self = shift;
    my ($date) = @_;
    my $dt = Date::Manip::ParseDate($date);
    return Date::Manip::UnixDate($dt, '%Y-%d-%m %H:%M:%S %p'); 
}

sub format_date
{
    my $self = shift;
    my ($date) = @_;
    my $dt = Date::Manip::UnixDate($date, '%Y-%d-%m');
   return $dt;
}

1;
