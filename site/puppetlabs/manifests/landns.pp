class puppetlabs::landns {
	dns::host {
		"dev-win7":
			ip   => "192.168.100.110",
			zone => "puppetlabs.lan";
		"dom01":
			ip   => "192.168.100.111",
			zone => "puppetlabs.lan";
		"dom02":
			ip   => "192.168.100.112",
			zone => "puppetlabs.lan";
		"dom03":
			ip   => "192.168.100.113",
			zone => "puppetlabs.lan";
		"dev-centos01":
			ip   => "192.168.100.115",
			zone => "puppetlabs.lan";
		"dev-centos01":
			ip   => "192.168.100.115",
			zone => "puppetlabs.lan";

	}

	dns::zone {
		"puppetlabs.lan":
			soaip => "192.168.100.125",
			soa   => "faro.puppetlabs.lan";
	}



}
