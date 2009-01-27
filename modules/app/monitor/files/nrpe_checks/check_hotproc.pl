#!/usr/bin/perl

use strict;

my $debug = 0;

my $highcpu = 0;
my (@hotprocs, $output, $hotproc, $thresshold, $command);

if (@ARGV == 2) {
  $thresshold = shift @ARGV;
  $command = shift @ARGV;
} elsif (@ARGV == 1) {
  $thresshold = shift @ARGV;
} elsif (@ARGV < 1) {
  $thresshold = 1;
} else {
  print "too many args, wtf?\n";
  exit (2);
}

open(PS, "ps axo %cpu,pid,command |") or die "Can't run ps: $!\n";

while(<PS>) {
  my %proc;
  chomp ;
  print "--------------------\n\n" if ($debug);
  print "output line: $_\n" if ($debug);
  ($proc{cpu},$proc{pid},$proc{command}) = $_ =~
/^\s+(\S+)\s+(\d+)\s(.+)$/;
  print "pid: $proc{pid}\ncommand: $proc{command}\ncpu: $proc{cpu}\n\n"
if ($debug);
  if ($proc{cpu} > $thresshold){
    if ( defined($command) ){
      if ( grep(/$command/,$proc{command}) ) {
        $highcpu = 1;
        push(@hotprocs, \%proc);
      }
    } else {
      $highcpu = 1;
      push(@hotprocs, \%proc);
    }
  }
}

if ( $highcpu ) {
  foreach $hotproc (@hotprocs){
    $output .= ", " if(defined($output));
    $output .= "[".$hotproc->{pid}.": ".$hotproc->{command}." - ".$hotproc->{cpu}."%]";
  }
  if ( defined($command) ) {
    print "hot $command processes: $output\n";
  } else {
    print "hot processes: $output\n";
  }
  exit (2);
} else {
  if ( defined($command) ) {
    $output = "no hot $command processes\n";
  } else {
    $output = "no hot processes\n";
  }
  print $output;
  exit (0);
}
