class mock {
	package {
		"mock": ensure => installed;
		"rpm-build": ensure => installed;
		"createrepo": ensure => installed;
		"git": ensure => installed;
	}

	group { "mock": members => "hudson", require => Package["mock"]; }

}
