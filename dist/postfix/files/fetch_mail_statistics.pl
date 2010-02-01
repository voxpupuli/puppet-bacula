#! /usr/bin/perl -W

#
# $Netilium: fetch_mail_statistics.pl,v 1.6 2004/11/07 21:59:11 mad Exp $
#
# Calculate and return number of sent / received e-mails on a system
# running the Postfix MTA. This is done by incrementally reading the
# log file, in a ``tail''-like fashion.
#                                              7th of November, 2004
#                                          http://netilium.org/~mad/
#                                Martin Adolfsson <mad@netilium.org>


#
# This defines how many seconds we will cache calculated values.
#
$MINRESET = 50;


if ( @ARGV < 5 ) {
print <<EOF
usage: fetch_mail_statistics.pl <maillog> <db file> <base oid> <request type> <requested oid>

 where:
   <maillog>         Mail log file, in Postfix compatible format.
   <db file>         File for logging statistics and timestamp data.
   <base oid>        The base OID this script is mounted on.
   <request type>    -n for SNMP getNext, or -g for SNMP get.
   <request oid>     Requested OID, in accordance with previous parameter

Report bugs to: <mad\@netilium.org>
EOF
;
exit;
}

$logFile  = $ARGV[0];
$dbFile   = $ARGV[1];
$baseOid  = $ARGV[2];

(@lf = stat $logFile) || die( "Cannot stat log file `".$logFile."'!" );
@st = stat $dbFile;

if ( ! @st ) {
  $timeSinceUpdated = 99999999;
  $logPosition      = $lf[7];
} else {
  $timeSinceUpdated = time()-$st[9];
  open( DBFILE, $dbFile ) || die( "Cannot open db file `".$dbFile."'!" );
  $logPosition=<DBFILE>;
  close( DBFILE );
  if ( $logPosition > $lf[7] ) {
    # Log has been truncated since last run.
    $logPosition = 0;
  }
}

if ( $timeSinceUpdated > $MINRESET ) {
  # Calculate and store new data.
  open( LOGFILE, $logFile ) || die( "Cannot open log file `".$logFile."'!" );
  seek( LOGFILE, $logPosition, 0 );
  $num_rec = 0;
  $num_sent = 0;
  $num_deferred = 0;
  $num_bounced = 0;
  $num_reject = 0;
  $num_clean = 0;
  $num_pspam = 0;
  $num_spam = 0;
  $num_infected = 0;
  $num_header = 0;
  $num_banned = 0;
  while( <LOGFILE> ) {
    if ( / postfix\/smtpd/ && /client=/ && ! /127.0.0.1/ ) { $num_rec++; }
    elsif ( /status=sent/ && ! /relay=(mailfilter|procmail|local|127.0.0.1)/ ) { $num_sent++; }
    elsif ( /status=deferred/ ) { $num_deferred++; }
    elsif ( /status=bounced/ ) { $num_bounced++; }
    elsif ( /: NOQUEUE: reject: / ) { $num_reject++; }
    elsif ( / Passed CLEAN/ ) { $num_clean++; }
    elsif ( / Passed SPAM/ ) { $num_pspam++; }
    elsif ( / Blocked SPAM/ ) { $num_spam++; }
    elsif ( / Blocked INFECTED/ ) { $num_infected++; }
    elsif ( / Passed BAD-HEADER/ ) { $num_header++; }
    elsif ( / Blocked BAD-HEADER/ ) { $num_header++; }
    elsif ( / Blocked BANNED/ ) { $num_banned++; }
  }
  open( DBFILE, ">".$dbFile ) || die( "Cannot write to db file `".$dbFile."'!" );
  print DBFILE tell(LOGFILE)."\n";
  print DBFILE $num_rec."\n";
  print DBFILE $num_sent."\n";
  print DBFILE $num_deferred."\n";
  print DBFILE $num_bounced."\n";
  print DBFILE $num_reject."\n";
  print DBFILE $num_clean."\n";
  print DBFILE $num_pspam."\n";
  print DBFILE $num_spam."\n";
  print DBFILE $num_infected."\n";
  print DBFILE $num_header."\n";
  print DBFILE $num_banned."\n";
  close( DBFILE );
}

# Return archived data.
open( DBFILE, $dbFile ) || die( "Cannot open db file `".$dbFile."'!" );
@data = ();
while( <DBFILE> ) { chomp; push @data, $_; }

$reqMethod = $ARGV[3];
$reqOid    = $ARGV[4];

if ( $reqMethod eq "-n" ) {
  # SNMP getNext request.
  if ( $reqOid eq $baseOid ) {
    print $baseOid.".0\ninteger\n".$data[1]."\n";
  } elsif ( $reqOid eq $baseOid.".0" ) {
    print $baseOid.".1\ninteger\n".$data[2]."\n";
  } elsif ( $reqOid eq $baseOid.".1" ) {
    print $baseOid.".2\ninteger\n".$data[3]."\n";
  } elsif ( $reqOid eq $baseOid.".2" ) {
    print $baseOid.".3\ninteger\n".$data[4]."\n";
  } elsif ( $reqOid eq $baseOid.".3" ) {
    print $baseOid.".4\ninteger\n".$data[5]."\n";
  } elsif ( $reqOid eq $baseOid.".4" ) {
    print $baseOid.".5\ninteger\n".$data[6]."\n";
  } elsif ( $reqOid eq $baseOid.".5" ) {
    print $baseOid.".6\ninteger\n".$data[7]."\n";
  } elsif ( $reqOid eq $baseOid.".6" ) {
    print $baseOid.".7\ninteger\n".$data[8]."\n";
  } elsif ( $reqOid eq $baseOid.".7" ) {
    print $baseOid.".8\ninteger\n".$data[9]."\n";
  } elsif ( $reqOid eq $baseOid.".8" ) {
    print $baseOid.".9\ninteger\n".$data[10]."\n";
  } elsif ( $reqOid eq $baseOid.".9" ) {
    print $baseOid.".10\ninteger\n".$data[11]."\n";
  }
} elsif ( $reqMethod eq "-g" ) {
  # SNMP get request.
  if ( $reqOid eq $baseOid || $reqOid eq $baseOid.".0" ) {
    print $baseOid.".0\ninteger\n".$data[1]."\n";
  } elsif( $reqOid eq $baseOid.".1" ) {
    print $baseOid.".1\ninteger\n".$data[2]."\n";
  } elsif( $reqOid eq $baseOid.".2" ) {
    print $baseOid.".2\ninteger\n".$data[3]."\n";
  } elsif( $reqOid eq $baseOid.".3" ) {
    print $baseOid.".3\ninteger\n".$data[4]."\n";
  } elsif( $reqOid eq $baseOid.".4" ) {
    print $baseOid.".4\ninteger\n".$data[5]."\n";
  } elsif( $reqOid eq $baseOid.".5" ) {
    print $baseOid.".5\ninteger\n".$data[6]."\n";
  } elsif( $reqOid eq $baseOid.".6" ) {
    print $baseOid.".6\ninteger\n".$data[7]."\n";
  } elsif( $reqOid eq $baseOid.".7" ) {
    print $baseOid.".7\ninteger\n".$data[8]."\n";
  } elsif( $reqOid eq $baseOid.".8" ) {
    print $baseOid.".8\ninteger\n".$data[9]."\n";
  } elsif( $reqOid eq $baseOid.".9" ) {
    print $baseOid.".9\ninteger\n".$data[10]."\n";
  } elsif( $reqOid eq $baseOid.".10" ) {
    print $baseOid.".10\ninteger\n".$data[11]."\n";
  }
}

