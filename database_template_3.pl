#!/usr/bin/perl
use strict;
use DBI;
use open ':std', ':encoding(UTF-8)';

# This template is for getting data from a database and saving it into a file

my $out_file = ""; # Output file path here
my $cls_dbi = "dbi:Pg:dbname=;host="; # Put DB name and Host here
my $cls_username = ""; # Put username here
my $cls_password = ""; # Put password here
my $TEMPLATE;
my $AC = 1; # auto-commit for dbh

my $dbh = DBI->connect($cls_dbi, $cls_username, $cls_password,
	{RaiseError =>1, pg_errorlevel=>0, PrintError=>0, AutoCommit=>$AC});

# Set sql as all the text that follows until you reach EOF
my $sql = <<"EOF";
select * from members;
EOF

my $sth = $dbh->prepare($sql);
eval {$sth->execute()};
die $@ if $@;
my $i = 0;
open (OUT, ">$out_file") or die "$out_file: $!";
while (my @row = $sth->fetchrow_array()) {
	print OUT join('|', @row), "\n";
	$i++;
}
close(OUT);
$sth->finish();
$dbh->disconnect();
print STDERR localtime(). ": $i records exported.\n";

# Template is the expected format of the data being read in/out
# Example
# $TEMPLATE = "A12 name 
#	       A250 age"
# 12 characters long for name - 250 characters long for age

BEGIN {
$TEMPLATE = "";
};
