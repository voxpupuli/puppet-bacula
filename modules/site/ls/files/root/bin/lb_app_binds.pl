#!/usr/bin/perl

my @virtual = qw{backcountry outlet tramdock dogfunk explore64 corp sac wm chainlove};
my @virtualssl = qw{backcountry outlet tramdock dogfunk explore64 sac wm chainlove};

my $no_bind = grep { /^-no$/ } @ARGV;

if (@ARGV) {
	@real = grep { $_ !~ /^-no$/ } @ARGV;
}
print "#Using real servers = ", join(',', @real), "\n";


my $httpmap = { 'backcountry' => 80,
                'outlet'      => 82,
                'dogfunk'     => 84,
                'tramdock'    => 86,
                'sac'         => 88,
                'corp'   => 90,
                'explore64'   => 92, 
				'wm'		  => 94,
				'chainlove'	  => 98,
 };

my $sslmap = { 'backcountry' => 81,
               'outlet'      => 83,
               'dogfunk'     => 85,
               'tramdock'    => 87,
               'sac'         => 89,
               'explore64'   => 93,
			   'wm' 		 => 95,
			   'chainlove'	 => 99,
 };

# HTTP settings              
my $str = ($no_bind ? 'no ' : '') .'bind http';
foreach my $v_server (@virtual) {
    print "server virtual $v_server\n";
    print $str;
    foreach my $r_server (@real) {
        print " $r_server $httpmap->{$v_server}";
    }
    print "\n";
    print "exit\n";
}

# SSL settings
$str = ($no_bind ? 'no ' : '') . 'bind ssl';
foreach my $v_serverssl (@virtualssl) {
    print "server virtual $v_serverssl\n";
    print $str;
    foreach my $r_server (@real) {
		print " $r_server $sslmap->{$v_serverssl}";
    }
    print "\n";
    print "exit\n";
}
