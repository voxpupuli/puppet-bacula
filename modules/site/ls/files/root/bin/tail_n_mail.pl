#!/usr/bin/perl

## Tail one or more files, mail the new stuff to one or more emails

use strict;
use warnings;
use Data::Dumper;
use File::Temp qw(tempfile);
use Getopt::Long;

## First option is always the config file, which must exist.
my $configfile = shift or die qq{Usage: $0 configfile\n};

my $MAILCOM = "/bin/mail";

## We never send more than this number of bytes
my $MAXSIZE = 400_000;

## Default message subject if not set elsewhere
my $DEFAULT_SUBJECT= 'Results for FILE';

## Read in the rest of the options
my ($verbose,$debug,$dryrun,$reset) = (0,0,0,0);
my $result = GetOptions
  (
   "verbose"  => \$verbose,
   "debug"    => \$debug,
   "dryrun"   => \$dryrun,
   "reset"    => \$reset,
  );
++$verbose if $debug;


## Read in the config file
open my $c, "<", $configfile or die qq{Could not open "$configfile": $!\n};
my %opt;
my $curr = "DEFAULT";
while (<$c>) {
  next if /^\s*#/;
  if (/^FILE:\s*(.+?)\s*$/) {
	$curr = $1;
	$opt{$curr} = 
	  {
	   email         => [],
	   exclude       => [],
	   include       => [],
	   mailsubject   => $DEFAULT_SUBJECT,
	   customsubject => 0,
	  };
  }
  elsif (/^EMAIL:\s*(.+?)\s*$/) {
	push @{$opt{$curr}{email}}, $1;
  }
  elsif (/^EXCLUDE:\s*(.+?)\s*$/) {
	push @{$opt{$curr}{exclude}}, $1;
  }
  elsif (/^INCLUDE:\s*(.+?)\s*$/) {
	push @{$opt{$curr}{include}}, $1;
  }
  elsif (/^OFFSET:\s*(\d+)/) {
	$opt{$curr}{offset} = $1;
  }
  elsif (/^MAILSUBJECT:\s*(.+)/) { ## Want whitespace
	$opt{$curr}{mailsubject} = $1;
	$opt{$curr}{customsubject} = 1;
  }
}
close $c;
for (keys %opt) { delete $opt{$_} if /^_/; }
$debug and warn Dumper \%opt;

## Any changes that need saving?
my $save = 0;

my ($fh, $tempfile);

## Process each file in turn:
for my $file (sort keys %opt) {
  next if $file eq 'DEFAULT';
  $verbose and warn "Checking file $file\n";
  ## Does it exist?
  if (! -e $file) {
	warn qq{WARNING! Skipping non-existent file "$file"\n};
	next;
  }
  my $size = -s _;
  ## Determine the new offset
  $opt{$file}{offset} ||= 0;
  my $offset = $opt{$file}{offset};
  $verbose and warn "  Offset: $offset Size: $size\n";
  if ($reset) {
	$offset = $size;
	$verbose and warn "  Resetting offset to $offset\n";
  }

  ## The file may have shrunk due to a logrotate
  if ($offset > $size) {
	$verbose and warn "  File has shrunk - resetting offset to 0\n";
	$offset = 0;
  }

  ## Read in the lines if necessary
 TAILIT: {
	if ($offset < $size) {

	  if ($size - $offset > $MAXSIZE) {
		warn "  SIZE TOO BIG (size=$size, offst=$offset): resetting to last $MAXSIZE bytes\n";
		$offset = $size - $MAXSIZE;
	  }

	  $offset = 10 if $offset < 10; ## We go back before the newline
	  open $fh, "<", $file or die qq{Could not open "$file": $!\n};
	  seek($fh,$offset-10,0);

	  ## Build an exclusion regex for this file
	  my $exclude = '';
	  for my $ex (@{$opt{$file}{exclude}}) {
		$debug and warn "  Adding exclusion: $ex\n";
		my $regex = qr{$ex};
		$exclude .= "$regex|";
	  }
	  $exclude =~ s/\|$//;
	  $verbose and $exclude and warn "  Exclusion: $exclude\n";

	  ## Build an inclusion regex for this file
	  my $include = '';
	  for my $in (@{$opt{$file}{include}}) {
		$debug and warn "  Adding inclusion: $in\n";
		my $regex = qr{$in};
		$include .= "$regex|";
	  }
	  $include =~ s/\|$//;
	  $verbose and $include and warn "  Inclusion: $include\n";

	  my $errors = '';
	  ## Discard previous line
	  $offset > 10 and <$fh>;
	  my $count = 0;
	  while (<$fh>) {
		next if $exclude and $_ =~ $exclude;
		next if $include and $_ !~ $include;
		$errors .= "$_\n";
		$count++;
	  }
	  $offset = tell($fh);
	  close $fh;

	  if (!$count) {
		$verbose and warn "  No new lines found in file\n";
		last TAILIT;
	  }

	  ## Create the mail message
	  ($fh, $tempfile) = tempfile;
	  print $fh "Lines from $file: $count\n\n$errors\n";
	  close $fh;

	  my $emails = join " " => @{$opt{DEFAULT}{email}}, @{$opt{$file}{email}};
	  $verbose and warn "  Sending mail to: $emails\n";
	  my $subject = $opt{$file}{mailsubject};
	  $subject =~ s/FILE/$file/g;
	  my $COM = qq{$MAILCOM -s '$subject' $emails < $tempfile};
	  if ($dryrun) {
		warn "  DRYRUN: $COM\n";
	  }
	  else {
		system($COM);
	  }
	  unlink $tempfile;
	}
  }

  ## If offset has changed, save it
  if ($offset != $opt{$file}{offset}) {
	$opt{$file}{offset} = $offset;
	$save++;
	$verbose and warn "  Setting offset to $offset\n";
  }
}

if ($save and !$dryrun) {
  $verbose and warn "Saving new config file (save=$save)\n";
  open $fh, ">", $configfile or die qq{Could not write "$configfile": $!\n};
  my $oldselect = select($fh);
  print qq{
## Config file for the tail_n_mail program
## This file is automatically updated
};


  for my $email (@{$opt{DEFAULT}{email}}) {
	print "EMAIL: $email\n";
  }

  for my $file (sort keys %opt) {
	next if $file eq 'DEFAULT';
	print "\nFILE: $file\n";
	print "OFFSET: $opt{$file}{offset}\n";
	for my $email (@{$opt{$file}{email}}) {
	  print "EMAIL: $email\n";
	}
	for my $exclude (@{$opt{$file}{exclude}}) {
	  print "EXCLUDE: $exclude\n";
	}
	for my $include (@{$opt{$file}{include}}) {
	  print "INCLUDE: $include\n";
	}
	if ($opt{$file}{customsubject}) {
	  print "MAILSUBJECT: $opt{$file}{mailsubject}\n";
	}

	print "\n";
  }
  select $oldselect;
  close $fh;
}

exit;
