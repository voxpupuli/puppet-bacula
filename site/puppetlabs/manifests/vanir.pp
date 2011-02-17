class puppetlabs::vanir {
	include puppetlabs::lan
	include pkgs::admin
	include apt-cacher

}
