#!/usr/bin/perl

    local ($buffer, @pairs, $pair, $name, $value, %FORM);
    # Read in text
    $ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
    if ($ENV{'REQUEST_METHOD'} eq "GET")
    {
	$buffer = $ENV{'QUERY_STRING'};
    }
    # Split information into name/value pairs
    @pairs = split(/&/, $buffer);
    foreach $pair (@pairs)
    {
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%(..)/pack("C", hex($1))/eg;
	$FORM{$name} = $value;
    }

if ($FORM{series} == 0)
{
	$series = 1;
}
else
{
	$series = $FORM{series};
}

$next = $series + $FORM{prior};

print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>A weird test</title>";
print "</head>";
print "<body>";
print "<h2>Current Series: $series</h2>";
print "<a href=\"?series=$next&prior=$series\">Next</a>";
print "</body>";
print "</html>";

1;