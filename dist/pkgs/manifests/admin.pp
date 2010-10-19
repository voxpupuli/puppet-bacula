class pkgs::admin {
	package {
		"rsync": ensure => installed;
		"htop": ensure => installed;
		"screen": ensure => installed;
	}

}
