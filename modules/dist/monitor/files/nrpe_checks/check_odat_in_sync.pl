#!/usr/local/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;

# This script connects to rootdb and livedb
# and verifies that the current item is the same
# for the given ODAT site.


# Get command line args
my %args;
GetOptions(\%args,
    'catalog_id=s',
    'verbose',
);

# Check for required args
if (! $args{catalog_id}) {
    die "missing required --catalog_id=... option!";
}

# Return codes
my %code = ( 'ok' => 0, 'warning' => 1, 'critical' => 2, 'unknown' => 3);

my $exit = sub {
    my ($level, $msg) = @_;
    $msg = uc($level) .": $msg";
    print $msg, $/;
    my $code = defined $code{$level} ? $code{$level} : $code{unknown};
    exit $code;
};


my $SQL = <<'EOQ';
SELECT sku_class
FROM woot_items
WHERE start_date = current_date
AND available_to_sell = true
AND catalog_id = ?
ORDER BY sort_order
LIMIT 1
EOQ

# Load rootdb
print "Connecting to rootdb.\n"  if $args{verbose};
my $root_dbh = DBI->connect('dbi:Pg:dbname=bcs;host=rootdb', 'bcs', 'cl1mb1ng')
    or die "Cannot connect to rootdb database: $DBI::errstr";
my ($rootdb_sku) = $root_dbh->selectrow_array($SQL, undef, $args{catalog_id});
$root_dbh->disconnect;
print "rootdb_sku = $rootdb_sku\n"  if $args{verbose};

# Load livedb
    print "Connecting to livedb.\n"  if $args{verbose};
my $live_dbh = DBI->connect('dbi:Pg:dbname=bcs;host=livedb', 'bcs', 'cl1mb1ng')
    or die "Cannot connect to livedb database: $DBI::errstr";
my ($livedb_sku) = $live_dbh->selectrow_array($SQL, undef, $args{catalog_id});
$live_dbh->disconnect;
print "livedb_sku = $livedb_sku\n"  if $args{verbose};


# Check if we're in sync for this rodb
if ($rootdb_sku eq $livedb_sku) {
	print "current item matches.\n"  if $args{verbose};
}
else {
    $exit->('critical', "rootdb_sku ($rootdb_sku) != livedb_sku ($livedb_sku)");
}


$exit->('ok', "The current ODAT item for $args{catalog_id} matches on rootdb and livedb.");



