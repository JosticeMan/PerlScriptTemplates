#!/usr/bin/perl -w

# This template is for reading in a file and inserting the records into a database table

use strict;
use DBI;
use MD5Check;
use Data::Dumper;
use Config::File qw(read_config_file);

my $config_hash = read_config_file(""); # Read database credentials from here

use constant FNAME => '.csv'; # Input file
use constant DEBUG => 1;

my $HOST = $config_hash->{WEB_DB_HOST};
my $auto_commit = 1;


my $TEMPLATE;

my $dbh = DBI->connect("dbi:Pg:dbname=;host=$HOST;","postgres","",
		{RaiseError=>1,AutoCommit=>$auto_commit});
$dbh->{pg_enable_utf8} = 1;
die $@ if $@;

my $sth = $dbh->prepare("INSERT INTO");

# Read data from file and update database
open(IN, FNAME) or die ("Open FNAME: $!\n");
flock(IN,1);
my $count = 0;
while (my $line = <IN>) {
	chomp $line;
	my @row = split(',', $line);
	shift @row; # Get the first element of the line 
	eval { $sth->execute(@row) };
	print STDERR Dumper \@row, $@ if $@;
	++$count;
}
close(IN);
$sth->finish();
$dbh->commit() unless $auto_commit;
$dbh->disconnect;
print STDERR "\n*** $count records inserted.\n" if DEBUG;

BEGIN {
$TEMPLATE = "";
};
