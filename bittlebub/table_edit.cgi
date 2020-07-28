#!/usr/bin/perl -w
use strict;
use CGI qw(:standard escapeHTML);
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;

use lib "/home2/itarswor/public_html/cgi-bin";
use iw_admin;

my $q = new CGI;
my $main = new iw_admin(database => 'itarswor_production');

my $session = $main->get_session();
if(!$session->param("uid"))
{
    print $q->redirect("login.cgi");
    exit;
}

my $dbh = $main->GetDBConnection();

my $tid = $q->param("tid");
my $action = $q->param('a') || '';


my $load_sql = qq[select * from table_edit where id = ?];
my $load_sth = $dbh->prepare($load_sql);
$load_sth->execute($tid);

our $table = $load_sth->fetchrow_hashref();

our $tablename = $table->{name};
our $load_event = '';

my $sql = qq[show columns from $tablename];
my $col_sth = $dbh->prepare($sql);

my @cols = ();
$col_sth->execute();

while (my $col = $col_sth->fetchrow_hashref()) {
#    print Dumper($col);
    next if($col->{Field} eq 'entered_uid');
    next if($col->{Field} eq 'entered_dt');
    next if($col->{Field} eq 'updated_uid');
    next if($col->{Field} eq 'updated_dt');
    push(@cols, $col->{Field});
}

my $edit_text = &build_edit;

print "Content-type: text/html\n\n";

print "<!DOCTYPE html>";
print qq[<HTML><HEAD><title>Itar's Workshop</title></head>];
print qq[<BODY>\n];

# write the jquery stuff
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-1.8.2.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/jquery-ui.min.js"></script>\n];
print qq[<script type="text/javascript" src="https://www.itarsworkshop.com/js/portamento.js"></script>\n];
print qq[<link href="https://www.itarsworkshop.com/js/jquery-ui.css" rel="stylesheet">\n];
#print qq[<link href="https://www.itarsworkshop.com/css/ui-lightness/jquery-ui-1.9.0.custom.css" rel="stylesheet">\n];
print qq[<link rel="stylesheet" type="text/css" href="tables.css" />\n\n];
print qq[<link href="menus.css" rel="stylesheet" />\n];
print qq[<script type="text/javascript" src="menus.js"></script>\n];

print qq[
    <table class="spacing" style="width:100%">
   <tr>
      <td colspan="3" style="text-align: center;"><h1>Itar's Workshop Internal Site</h1></td>
   </tr>
   <tr>
      <td><h2 style="text-align:center;"></h2></td>
      <td>&nbsp;</td>
      <td>
];
print $main->getMenu();

print qq[
      </td>
   </tr>
</table>
];
if ($action eq 'edit' || $action eq 'add') {
    &save();
} elsif ($action eq 'show_edit') {
    print &build_edit;
}

print qq[
<script>
\$(function() {
   \$('#div_edit').dialog({autoOpen : false, width : 400});
   $load_event
});

function show_edit(type, row) {
    var title = 'Add Item';

    if(type=='edit') {
        title = 'Edit Item';
];

foreach my $c (@cols) {
#    next if($c eq 'id');
    print qq[\$('#$c').val(\$('#' + row + '_$c').html())\n];
}

print qq[
    }
    else {
];

foreach my $c (@cols) {
#    next if($c eq 'id');
    print qq[\$('#$c').val('')\n];
}

print qq[
    }
    \$('#div_edit').dialog('option', 'title', title);
    \$('#edit_a').val(type);

\$('#edit_a').val(type);
\$('#div_edit').dialog("open");
}
</script>\n
];
print qq[<h1 style="text-align:center;">Table Edit</h1>\n];


print qq[<h2 style="text-align:center;">$tablename</h2>\n];

print qq[<div style="margin-left:auto; margin-right:auto;text-align:center;"><a href="" onclick="show_edit('add', 0); return false;" style="text-align:center;">Add new row</a></div>\n];
print qq[<table class="list" style="margin-left: auto;margin-right: auto; width:80%;">\n];
print "<tr><th></th>";
foreach my $c (@cols)
{
    print "<th>$c</th>"
}

print "</tr>";
$sql = qq[select * from $tablename];

my $sth = $dbh->prepare($sql);
$sth->execute();

my $count = 0;
while (my $row = $sth->fetchrow_hashref()){
    print "<tr>";
    print qq[<td><a href="" onclick="show_edit('edit', $count); return false;"><span class="ui-icon ui-icon-pencil"></span></a></td>\n];
    
    foreach my $c (@cols) {
        my $id_val = $count . "_" . $c;
        print qq[<td><span id="$id_val">$row->{$c}</span></td>\n];
    }
    print "</tr>";
    $count++;
}

print "</table>";

print qq[
    <div name="div_edit" id="div_edit" style="display:none;" title="Add Record">
];

print $edit_text;
print "</div>\n";

exit;

sub build_edit {
    my $sql = qq[show columns from $tablename];
    my $col_sth = $dbh->prepare($sql);
    
    my @cols = ();
    $col_sth->execute();
    
    my $output = qq[<form name="frm_save" method="post">\n<input type="hidden" name="a" id="edit_a" value="$action">\n<input type="hidden" name="tid" id="tid" value="$tid">];
    $output .= qq[<table class="spacing" border="0"><tr><td>\n];
    
    my %type = %{&build_input_type};
    while (my $col = $col_sth->fetchrow_hashref()) {
        next if($col->{Field} eq 'entered_uid');
        next if($col->{Field} eq 'entered_dt');
        next if($col->{Field} eq 'updated_uid');
        next if($col->{Field} eq 'updated_dt');

        my ($db_type, $size) = split /\(/, $col->{Type};
        $size =~ s/\)\s*//;
        my $value = ($action eq 'edit') ? $table->{$col->{Field}} : '';
        if ($db_type eq 'text') {
            $output .= qq[<tr><td style="text-align:right;">$col->{Field}</td><td><textarea name="$col->{Field}" id="$col->{Field}">$value</textarea></td></tr>\n];
        } else {
            $output .= qq[<tr><td style="text-align:right;">$col->{Field}</td><td><input type="$type{$db_type}{type}" value="$value" name="$col->{Field}" id="$col->{Field}];
            $output .= qq["></td></tr>\n];
        }
        
        if ($db_type eq 'date') {
            $load_event .= qq[\$('#$col->{Field}').datepicker();];
        }
        
    }
    
    $output .= qq[</table>\n];
    $output .= qq[<input type="submit" name="save" value="Save">];
    $output .= qq[</form>\n];
}

sub build_input_type
{
    my %type = ();
    
    $type{varchar} = {type => "text"};
    $type{text} = {type => "textarea"};
    $type{int} = {type => "text"};
    $type{date} = {type => "text"};
    $type{bit} = {type => "checkbox"};
    
    return \%type;
}

sub save
{
    my $id = $q->escapeHTML($q->param('id'));
    my %form = $q->Vars();
    $form{tablename} = $tablename;

    my $table_sql = qq[show columns from $tablename];
    my $col_sth = $dbh->prepare($table_sql);
    $col_sth->execute();
    
    while(my $col = $col_sth->fetchrow_hashref())
    {
        if ($col->{Type} =~ /^bit/) {
            $form{$col->{Field}} = (exists $form{$col->{Field}}) ? 1 : 0;
        }    
    }
    
    $main->dbx_save($tablename, \%form, $id);
    
    return; # skip the rest.  test the current data
    
    my $table_sql = qq[show columns from $tablename];
    my $col_sth = $dbh->prepare($table_sql);
    
#    my @cols = ();
    $col_sth->execute();
    
    my $fields = '';
    my $inserts = '';
    my @values = ();
    
    while(my $col = $col_sth->fetchrow_hashref())
    {
        next if ($col->{Field} eq 'id');
        if ($action eq 'edit') {
            $fields .= qq[$col->{Field} = ?,];
            push(@values, $q->escapeHTML($q->param("$col->{Field}")));
        } elsif ($action eq 'add') {
            $fields .= qq[$col->{Field},];
            $inserts .= "?,";
            push(@values, $q->escapeHTML($q->param("$col->{Field}")));
        }
    }
    chop $fields;
    chop $inserts;
    my $sql = '';
    if ($action eq 'edit') {
        $sql = qq[update $tablename set $fields where id = ?];
        push(@values, $id);
    } elsif($action eq 'add') {
        $sql = qq[insert into $tablename ($fields) VALUES ($inserts)];
    }
    
    my $save_sth = $dbh->prepare($sql);
    $save_sth->execute(@values);
}