class dns::params {
    $dnsdir = $operatingsystem ? {
        debian => "/etc/bind9",
        ubuntu => "/etc/bind9",
        centos => "/etc/dns",
        darwin => "/etc/dns",
        default => "/etc/dns",
    }
    $dns_server_package = $operatingsystem ? {
        debian => "bind9",
        ubuntu => "bind9",
        centos => "bind",
        default => undef,
    }
		$namedgroup = $operatingsystem ? {
			darwin => 0,
			default => "named",
		}
    $namedconf_path = "/etc/named.conf"
    $vardir = "/var/named"
    $optionspath = $operatingsystem ? {
        darwin => "${dnsdir}/options.conf.apple",
        default => "${dnsdir}/options.conf",
    }

    #pertaining to rndc
    $rndckeypath = "/etc/rndc.key"
    $rndc_alg = "hmac-md5"
    $rndc_secret = "APIEQEbbut1VcDEC/p8PRg=="

    #pertaining to views
    $publicviewpath = $operatingsystem ? {
        darwin => "${dnsdir}/publicView.conf.apple",
        default => "${dnsdir}/publicView.conf",
    }
    $publicview = $operatingsystem ? {
        darwin => "com.apple.ServerAdmin.DNS.public",
        default => "DNS.public",
    }

    $zonefilepath = "${vardir}/zones"
    $namedservicename = $operatingsystem ? {
        darwin => "org.isc.named",
        centos => "named",
				default => "named",
    }
}

