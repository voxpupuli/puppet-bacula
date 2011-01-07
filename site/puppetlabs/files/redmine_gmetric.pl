#! /usr/bin/perl

use strict;

my $outfile="/tmp/puppet_project.html";
my $puppet_project_url="http://projects.puppetlabs.com/projects/puppet/";

`wget -q -O $outfile $puppet_project_url`;

my %data = (
  # name => search,
  openbugs => '>Bug<',
  openfeature => '>Feature<',
  openrefactor => '>Refactor<',
);

foreach my $name (keys %data) {
  my $cmd = "grep -A 1 '$data{$name}' $outfile | tail -n 1 | awk \'{ print \$1 }\'";
  my $return = `$cmd`;
  chomp $return;
  `/usr/bin/gmetric -c /etc/ganglia/gmond.conf -n $name -v $return --type=int16`;
}

