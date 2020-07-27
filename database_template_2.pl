#!/usr/bin/perl -w

use strict;
use DBI;
use Data::Dumper;

# This template is for getting data from a file and then writing the results to an database table

use constant FNAME => ''; # Input file path here
use constant DEBUG => 1;

my $auto_commit = 1;

my $TEMPLATE;

my $dbh = DBI->connect("dbi:Pg:dbname=;host=",'','',
		{RaiseError=>1,AutoCommit=>$auto_commit});
$dbh->{pg_enable_utf8} = 1;

my $sql = <<"EOF";
insert into member;
EOF

my $sth = $dbh->prepare($sql);
;
# Read data from file and update database
open(IN, FNAME) or die ("Open FNAME: $!\n");
flock(IN,1);
my $count = 0;
while (my $line = <IN>) {
	chomp $line;
	#my @row = unpack($TEMPLATE, $line);
	my @row = split('\|', $line);
    for (@row[0..18]) {
        $_ = undef unless $_;
    }
    my $address_id = $row[0];
	eval { $sth->execute($address_id) };
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
