#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use DBI;

# nagios: -epn

my $options = { 'master' => 'server1', 'slave' => 'server2', 'crit' => 1000000000, 'warn' => 10000000 , 'dbuser' => 'repl_test', 'dbpass' => 'secret'};
GetOptions($options, "master=s", "slave=s", "dbuser=s", "dbpass=s", "crit=i", "warn=i", "help");
my $max_binlog;

if (defined $options->{'help'}) {
	print <<FOO;
$0: check replication between mysql databases

 check_replication.pl [ --master <host> ] [ --slave <host> ] 
 [ --crit <positions> ] [ --warn <positions> ] [ --dbuser <user> ] 
 [ --dbpass <pass> ]

  --master <host>    - MySQL instance running as a master server, <host> may contain a :port suffix
  --slave <host>     - MySQL instance running as a slave server, <host> may contain a :port suffix
  --crit <positions> - Number of binlog positions for critical state
  --warn <positions> - Number of binlog positions for warning state
  --dbuser <user>    - Username with File and Process privs to check status
  --dbpass <pass>    - Password for above user
  --help             - This help page

The user that is testing must be the same on all instances, eg:
  GRANT File, Process on *.* TO repl_test\@192.168.0.% IDENTIFIED BY <pass>

Note: Any mysqldump tables (for backups) may lock large tables for a long 
time. If you dump from your slave for this, then your master will gallop 
away from your slave, and the difference will become large. The trick is to 
set crit above this differnce and warn below.

(c) 2004 Fotango. James Bromberger <jbromberger\@fotango.com>.
Extended 2007: Initfour websolutions, Herman van Rink <rink\@initfour.nl>.
FOO
exit;
}

sub get_status {
	my $host = shift;
	my $role = shift;
	my $port = 3306;

	# Check for a non default port
	if ( $host =~ m/^(.*):(\d+)$/ ) {
		$host = $1;
		$port = $2;
	}

	# Connect to the server
	# Since no priviledges can be assumed for a specific database the format of DBI:mysql:database@host:port could not be used
	my $dbh = DBI->connect("DBI:mysql:host=$host;port=$port", $options->{'dbuser'}, $options->{'dbpass'});
	if (not $dbh) {
		print "UNKNOWN: cannot connect to $host";
		exit 3;
	}

	if (lc ($role) eq 'master') {
		my $sql1 = "show variables like 'max_binlog_size'";
		my $sth1 = $dbh->prepare($sql1);
		my $res1 = $sth1->execute;
		my $ref1 = $sth1->fetchrow_hashref;
		$max_binlog = $ref1->{'Value'};
	}
	my $sql = sprintf "SHOW %s STATUS", $role;
	my $sth = $dbh->prepare($sql);
	my $res = $sth->execute;
	if (not $res) {
		die "No results";
	}
	my $ref = $sth->fetchrow_hashref;
	$sth->finish;
	#print "$host:\n";
	#print join (', ', map { sprintf " %s: %s", $_, $ref->{$_} } keys %{$ref}) . "\n";
	$dbh->disconnect;
	return $ref;
}

sub compare_status {
	my ($a, $b) = @_;
	my ($master, $slave);

	# Find out which argument contains the master and wich the slave data
	if (defined($a->{'File'})) {
		$master = $a;
		$slave = $b;
	} elsif (defined($b->{'File'})) {
		$master = $b;
		$slave = $a;
	}

	# Extract file number from the filename's
	$master->{'File_No'} = $1 if ($master->{'File'} =~ /(\d+)$/);
	$slave->{'File_No'} = $1 if ($slave->{'Relay_Master_Log_File'} =~ /(\d+)$/);

	# Debug, just to simulate a situation where the master is far ahead of the slave
	#$master->{'File_No'}++;
	#$master->{'Position'} = $master->{'Position'} + 104857600;

	# Take file rotation into account
	my $diff = ($master->{'File_No'} - $slave->{'File_No'}) * $max_binlog;
	$diff += $master->{'Position'} - $slave->{'Exec_Master_Log_Pos'};
	
	my $state = sprintf "Master: %d/%d  Slave: %d/%d  Diff: %d/%d\n", 
				$master->{'File_No'}, $master->{'Position'}, 
				$slave->{'File_No'}, $slave->{'Exec_Master_Log_Pos'}, 
				($diff/$max_binlog), ($diff % $max_binlog);

	if ($diff >= $options->{'crit'}) {
		print "CRITICAL: $state";
		exit 2;
	} elsif ($diff >= $options->{'warn'}) {
		print "WARN: $state";
		exit 1;
	}
	print "OK: $state";
	exit 0;
}

compare_status(get_status($options->{'slave'}, 'slave'), get_status($options->{'master'}, 'master'));
