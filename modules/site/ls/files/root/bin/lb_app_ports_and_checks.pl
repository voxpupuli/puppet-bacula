#!/usr/bin/perl



#my @servers = qw{nile darling dinkey snake volga rhine zigzag colorado congo elbert boivin};
my @servers = qw{mammoth powder arapahoe};

if (@ARGV) {
	@servers = @ARGV;
}
print "Using servers = ", join(',', @servers), "\n";

my @regular_ports   = qw{80 81 82 83 84 85 90 92 93};
my @odat_ports      = qw{88 89 94 95 86 87 94 95 98 99 };

my @ports = sort (@regular_ports, @odat_ports);

my $portmap = { 80 => 'www.backcountry.com',
                81 => 'www.backcountry.com',
                82 => 'www.backcountryoutlet.com',
                83 => 'www.backcountryoutlet.com',
                84 => 'www.dogfunk.com',
                85 => 'www.dogfunk.com',
                86 => 'www.tramdock.com',
                87 => 'www.tramdock.com',
                88 => 'www.steepandcheap.com',
                89 => 'www.steepandcheap.com',
                90 => 'www.backcountrycorp.com',
                92 => 'www.explore64.com',
                93 => 'www.explore64.com',
				94 => 'www.whiskeymilitia.com',
				95 => 'www.whiskeymilitia.com', 
				98 => 'www.chainlove.com',
				99 => 'www.chainlove.com' };

my $catalog = { 80 => 'store',
                81 => 'store',
                82 => 'outlet',
                83 => 'outlet',
                84 => 'dogfunk',
                85 => 'dogfunk',
                86 => 'tramdock',
                87 => 'tramdock',
                88 => 'steepcheap',
                89 => 'steepcheap',
                90 => 'corporate',
                92 => 'explore64',
                93 => 'explore64',
				94 => 'wm',
				95 => 'wm',
				98 => 'chainlove',
				99 => 'chainlove' };


foreach my $a_server (@servers) {
	my $a_ip=`grep $a_server /etc/hosts | awk '{print \$1}'`;
    print "server real $a_server $a_ip";
	print "source-nat\n";
	print "weight 4 0\n";
    foreach my $a_port (@ports) {
        print "port $a_port\n";
        print "port $a_port keepalive\n";
        # print "port $a_port url \"HEAD /\"\n";
        #print "port $a_port url \"GET /$catalog->{$a_port}/bc_server_agent.html HTTP/1.1\\r\\nHost: $portmap->{$a_port}\\r\\nUser-Agent: FoundrySI\\r\\n\\r\\n\"\n";
        print "port $a_port url \"HEAD /robots.txt HTTP/1.1\\r\\nHost: $portmap->{$a_port}\\r\\nUser-Agent: FoundrySI\\r\\n\\r\\n\"\n";
    }
	print "\n\n";
    print "exit\n";
}
