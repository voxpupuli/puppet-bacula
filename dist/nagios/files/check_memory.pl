#!/usr/bin/perl -w
# check_memory - nagios plugin modified by Empowering Media to
# calculate memory usage minus buffers/cache.
#
# $Id: check_mem.pl,v 1.1.1.1 2002/02/28 06:42:54 egalstad Exp $

# check_mem.pl Copyright (C) 2000 Dan Larsson <dl@tyfon.net>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# you should have received a copy of the GNU General Public License
# along with this program (or with Nagios);  if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA

# Tell Perl what we need to use
use strict;
use Getopt::Std;

use vars qw($opt_c $opt_f $opt_i $opt_u $opt_w
	    $free_memory $used_memory $total_memory
	    $buff_memory $cach_memory $buffcache
	    $crit_level $warn_level
            %exit_codes @memlist
            $percent $fmt_pct 
            $verb_err $command_line);

# Predefined exit codes for Nagios
%exit_codes   = ('UNKNOWN' ,-1,
		 'OK'      , 0,
                 'WARNING' , 1,
                 'CRITICAL', 2,);

# Turn this to 1 to see reason for parameter errors (if any)
$verb_err     = 1;

# This the unix command string that brings Perl the data
$command_line = `free | tail -3 | awk '{print \$2,\$3,\$4,\$6,\$7}'`;

$command_line = (split(/\n/, $command_line))[0];
@memlist      = split(/ /, $command_line);

# Define the calculating scalars
$total_memory  = $memlist[0];
$used_memory  = $memlist[1];
$free_memory  = $memlist[2];
$buff_memory  = $memlist[3];
$cach_memory  = $memlist[4];

# Get the options
if ($#ARGV le 0)
{
  &usage;
}
else
{
  getopts('c:fiuw:');
}

# Consider buffers/cache as free. (Default behavior)
if ( !$opt_i ) {
  $buffcache = $buff_memory + $cach_memory;
  $free_memory += $buffcache;
  $used_memory -= $buffcache;
}

# Shortcircuit the switches
if (!$opt_w or $opt_w == 0 or !$opt_c or $opt_c == 0)
{
  print "*** You must define WARN and CRITICAL levels!" if ($verb_err);
  &usage;
}
elsif (!$opt_f and !$opt_u)
{
  print "*** You must select to monitor either USED or FREE memory!" if ($verb_err);
  &usage;
}

# Check if levels are sane
if ($opt_w <= $opt_c and $opt_f)
{
  print "*** WARN level must not be less than CRITICAL when checking FREE memory!" if ($verb_err);
  &usage;
}
elsif ($opt_w >= $opt_c and $opt_u)
{
  print "*** WARN level must not be greater than CRITICAL when checking USED memory!" if ($verb_err);
  &usage;
}

$warn_level   = $opt_w;
$crit_level   = $opt_c;

if ($opt_f)
{
  $percent    = $free_memory / $total_memory * 100;
  $fmt_pct    = sprintf "%.1f", $percent;
  if ($percent <= $crit_level)
  {
    print "Memory CRITICAL - $fmt_pct% ($free_memory kB) free\n";
    exit $exit_codes{'CRITICAL'};
  }
  elsif ($percent <= $warn_level)
  {
    print "Memory WARNING - $fmt_pct% ($free_memory kB) free\n";
    exit $exit_codes{'WARNING'};
  }
  else
  {
    print "Memory OK - $fmt_pct% ($free_memory kB) free\n";
    exit $exit_codes{'OK'};
  }
}
elsif ($opt_u)
{
  $percent    = $used_memory / $total_memory * 100;
  $fmt_pct    = sprintf "%.1f", $percent;
  if ($percent >= $crit_level)
  {
    print "Memory CRITICAL - $fmt_pct% ($used_memory kB) used\n";
    exit $exit_codes{'CRITICAL'};
  }
  elsif ($percent >= $warn_level)
  {
    print "Memory WARNING - $fmt_pct% ($used_memory kB) used\n";
    exit $exit_codes{'WARNING'};
  }
  else
  {
    print "Memory OK - $fmt_pct% ($used_memory kB) used\n";
    exit $exit_codes{'OK'};
  }
}

# Show usage
sub usage()
{
  print "\ncheck_mem.pl v1.0 - Nagios Plugin\n\n";
  print "usage:\n";
  print " check_mem.pl <-i> -<f|u> -w <warnlevel> -c <critlevel>\n\n";
  print "options:\n";
  print " -i	       Include buffers/cache in used memory\n";
  print " -f           Check FREE memory\n";
  print " -u           Check USED memory\n";
  print " -w PERCENT   Percent free/used when to warn\n";
  print " -c PERCENT   Percent free/used when critical\n";
  print "\nCopyright (C) 2000 Dan Larsson <dl\@tyfon.net>\n";
  print "check_mem.pl comes with absolutely NO WARRANTY either implied or explicit\n";
  print "This program is licensed under the terms of the\n";
  print "GNU General Public License (check source code for details)\n";
  print "This plugin has been modified for use by Empowering Media.\n";
  exit $exit_codes{'UNKNOWN'}; 
}
