#!/usr/local/bin/perl

use strict;
use warnings;

# This script checks the homepages are in sync
# and auto-fixes any that are not.

print "Starting at ". localtime() ."\n";

my %servers;

# Loop through catalogs
my @catalogs = qw/steepcheap wm chainlove tramdock/;

foreach my $cat (@catalogs) {
	my $out = `/usr/local/libexec/check_odat_homepage_in_sync.pl --catalog_id=$cat`;
    print "$out\n";
    if ($out =~ /^CRITICAL: /) {
        while ($out =~ s/\s*,?\s*(\w+) \(\w+\) != livedb_sku \(\w+\)\s*,?\s*//) {
            $servers{$1} = 1;
		}
	}
}

if (%servers) {
    my $servers = join(' ', keys %servers);
    print "Calling reset_mvc_cached $servers\n";
    my $out = `/root/bin/reset_mvc_cached $servers`;
}

print "Done at ". localtime() ."\n";
