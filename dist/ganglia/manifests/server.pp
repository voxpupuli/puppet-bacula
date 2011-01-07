class ganglia::server {

	include ganglia

	package {
		"ganglia-monitor": ensure => installed;
		"ganglia-webfrontend": ensure => installed;
	}

}
