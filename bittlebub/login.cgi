#!/usr/bin/perl -w
use strict;
#use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use CGI;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

#print "Content-type: text/plain\n\n";
my $key = 'IWS_ADMIN13#';

my $q = new CGI;
my $main = new iw_admin(database => 'itarswor_production');
our %vars = $q->Vars();

my $action = $q->param("a") || '';
my $uid = $q->param('uid');
my $redirect_target = $q->param("target") || 'home.cgi';
my $msg = '';

our $allow_register = 0;

our $dbh = $main->GetDBConnection();
my $session = $main->get_session();

$main->logit("login.cgi - action [$action]");

our $create = 0;
if($action eq 'create')
{
   create_account();
   default();
}
elsif($action eq 'login')
{
    login();
    default();
}
elsif($action eq 'logout')
{
    $main->logout();
    default();
#    print $q->redirect('pledge_manager.cgi');
}
else
{
    default();
}

exit;

###########################################
sub default
{
    our $session = $main->get_session();
    
    print "Content-type: text/html\n\n";
    #$main->WriteHeader("Itar's Workshop - Kickstarter Pledge Manager");
    print "<!DOCTYPE html>";
    print qq[<HTML><HEAD><title>Itar's Workshop</title></head>];
    print qq[<BODY>\n];
    
    # write the jquery stuff
    #print qq[<script type="text/javascript" src="http://www.itarsworkshop.com/js/jquery-1.8.2.js"></script>\n];
    print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-2.0.2.js"></script>\n];
    print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.js"></script>\n];
    print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.min.js"></script>\n];
    print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/portamento.js"></script>\n];
    print qq[<link href="https://www.itarsworkshop.com/css/ui-lightness/jquery-ui-1.9.0.custom.css" rel="stylesheet">\n];
    print qq[<link rel="stylesheet" type="text/css" href="https://www.itarsworkshop.com/js/tables.css" />\n\n];
    
    
    #if($action eq 'create')
    #{
    #    $create = 1;
    #}
    print <<EOF;
    <script type="text/javascript">
    
    function toggle_display()
    {
        \$('#login').toggle();
        \$('#create').toggle();
    }
    
    </script>
    
    <h1 style="text-align:center">Itar's Workshop</h1>
    
    <h4 style="text-align:center;color:red;">$msg</h4>
EOF
    
    print qq[<div id="login"];
    if($create)
    {
        print qq[style="display:none;"];
    }
    print qq[ style="text-align:center">\n];
    
    print <<EOF;
    <form name="frm_login" id="frm_login" style="text-align:center" method="post">
    <input type="hidden" name="a" value="login">
    User: <input type="text" name="user" id="user"><br />
    Password: <input type="password" name="password" id="pw"><br />
    <input type="submit" value="Login"><br>
    </form>
    <a href="?a=logout">logout</a>
    <span style="text-align:center;margin-left: auto;margin-right: auto;">
EOF
   if ($allow_register) {
      print qq[<a href="" onclick="toggle_display(); return false;">Create an Account</a><br />];
   }
}

sub login
{
#   $main->logout();
   my @required = qw/user password/;
   foreach my $req (@required)
   {
#    $main->logit( "$req = $vars{$req}");
       if(!defined($vars{$req}) || $vars{$req} eq '')
       {
           $msg .= qq[$req is a required field<br>];
       }
   }
   if($msg)
   {
      $create = 0;
      return 0;
   }
   
$main->logit("login sub");
   my $sql = qq[select a.* from admin_users a where a.uid = ? and a.password = aes_encrypt(?, '$key') and a.active = 'Y'];
   
   my $login_sth = $dbh->prepare($sql);
   
   $login_sth->execute($vars{user}, $vars{password});
   my $rec = $login_sth->fetchrow_hashref();
   
   my $session = $main->get_session();
    # merge the saved cart with any cart currently existing
   $session->clear();
$main->logit("got session");

   if(defined($rec))
   {
       foreach my $k (keys %{$rec})
       {
           next if $k eq 'password';
           $session->param($k, $rec->{$k});
           $main->logit("param [$k] value [" . $session->param($k) . "]");
#           print qq[Param : ] . $session->param($k);
           
       }

#$main->logit("session hash [" . Dumper($session->dataref) . "]");
       my $location = qq[$redirect_target];
       if ($location !~ /^\s*http/) {
          $location = qq[https://www.itarsworkshop.com/bittlebub/$location];
       }
$main->logit("redirect target [$location]");
#       print $main->redirect(-url => $location);
       print $q->redirect("$location");
#       print $q->redirect('home.cgi');
       
       # update the last login info
       my $last_sql = qq[update admin_users set last_login = now()];
       $dbh->do($last_sql);
   }
   else
   {
      $msg = qq[Invalid user/password combination];
   }
   
#   $main->redirect("home.cgi");
    
}

sub recover_pw
{
    my $code = $main->generate_random_string(10);
    
    my $sql = qq[update admin_users set password = aes_encrypt(?, '$key') where lower(email) = lower(?)];
    my $email = $q->param('email');
    
$main->logit("recover password for email [$email]");

    if(!$email)
    {
        $msg = 'You must specify an email address for the account you want to reset the password';
        show_recover();
        exit;
    }
    my $pw_sth = $dbh->prepare($sql);
    $pw_sth->execute($code, $email);
    $main->logit("sql error[" . $pw_sth->errstr() . "]");
    
    my $msg = qq[
      You have requested to reset your password on Itar's Workshop Pledge Manager.
      
      Your password has been reset to: $code
      
      To change your password once you login go to My Account page and click the 'update info' link
    ];
    my %mail = (
        to => $email,
        from => 'itar@itarsworkshop.com',
        subject => 'Itar\'s Workshop Pledge Manager Password Reset Request',
        message => $msg
    );
    
   $main->logit("mail parameters [" . Dumper(\%mail) . "]");
   
    my $mailprog = '/usr/sbin/sendmail -i -t';
    open(MAIL, "|$mailprog") or die "cannot open send mail";
   print MAIL "To: $mail{to}\n";
   print MAIL "FROM: $mail{from}\n";
   print MAIL "SUBJECT: $mail{subject}\n";
   print MAIL "Content-type: text/plain\n\n";
   print MAIL "$mail{message}\n";
   close(MAIL);
#    $main->send_email(\%mail);
}

sub show_update
{
    print "Content-type: text/html\n\n";
#$main->WriteHeader("Itar's Workshop - Kickstarter Pledge Manager");
print "<!DOCTYPE html>";
print qq[<HTML><HEAD><title>Itar's Workshop</title></head>];
print qq[<BODY>\n];

# write the jquery stuff
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-1.8.2.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui-1.9.0.custom.min.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/portamento.js"></script>\n];
print qq[<link href="https://www.itarsworkshop.com/css/ui-lightness/jquery-ui-1.9.0.custom.css" rel="stylesheet">\n];
print qq[<link rel="stylesheet" type="text/css" href="https://www.itarsworkshop.com/js/tables.css" />\n\n];


#if($action eq 'create')
#{
#    $create = 1;
#}
print <<EOF;
<script>
\$(function() {
 
});

function toggle_display()
{
    \$('#login').toggle();
    \$('#create').toggle();
}

</script>

<h1 style="text-align:center">Itar's Workshop Pledge Manager Update Account Info</h1>

<h4 style="text-align:center;color:red;">$msg</h4>
EOF
write_menu();
print qq[<div id="create" style="text-align:center;];
print qq[">\n];

print <<EOF;
<form name="frm_create" id="frm_create" style="text-align:center" method="post">
<input type="hidden" name="a" value="save">
Email: <input type="text" name="email" id="email" value="$vars{email}"><br />
Name: <input type="text" name="name" id="name" value="$vars{name}"><br/>
Address 1: <input type="text" name="address_1" value="$vars{address_1}"><br/>
Address 2: <input type="text" name="address_2" value="$vars{address_2}"><br/>
City: <input type="text" name="city" value="$vars{city}"><br/>
State: <input type="text" name="state" value="$vars{state}"><br/>
Postal Code: <input type="text" name="postal_code" value="$vars{postal_code}"><br/>
Country: <input type="text" name="country" value="$vars{country}"><br/>
<br/><br/>
<b>Reset Password</b><br/>
Old Password: <input type="password" name="old_password"></br>
Password: <input type="password" name="password_1"><br/>
Retype Password: <input type="password" name="password_2"><br/>
<input type="submit" value="Save">
</form>

</div>

EOF

}

sub show_recover
{
    print "Content-type: text/html\n\n";
    print "<!DOCTYPE html>";
    print qq[<HTML><HEAD><title>Itar's Workshop</title></head>];
    print qq[<BODY>\n];

 #   print qq[<div id="login"];
#    print qq[<h1 style="text-align:center;">Itar's Workshop Pledge Manager</h1>\n];
#    print qq[<h2 style="text-align:center">Reset your password</h2>\n];
#    print qq[<span style="text-align:center;">You will be sent an email with your new password.</span>\n];
    
    print <<EOF;
    <div id="login">
    <h1 style="text-align:center">Itar's Workshop Pledge Manager</h1>
    <h2 style="text-align:center">Reset your password</h2>
    <table border="0" style="margin-left: auto;margin-right: auto;">
    <tr><td style="text-align:center;">
        <span style="text-align:center;">You will be sent an email with your new password.</span>
    </td></tr>
    <h4 style="text-align:center;color:red;">$msg</h4>
    
    <form name="frm_login" id="frm_login" style="text-align:center" method="post">
    <input type="hidden" name="a" value="recover">
    
    <tr><td style="text-align:center;">
        Email: <input type="text" name="email" id="email"><br />
    </td></tr>
    <tr><td style="text-align:center;">
    <input type="submit" value="Reset Password"><br>
    </td></tr>
    </form>
    <tr><td style="text-align:center;">
        <a href=?login.cgi">Login</a>
    </td></tr>
    <tr><td style="text-align:center;">
EOF
if ($allow_register) {
   print qq[<a href="login.cgi?a=show_create" style="text-align:center;">Create an Account</a>];
}

print <<EOF;
    </td></tr>
    
    </table>
    </span>
    </div>
EOF

}
