class puppetlabs::vanir {
	include puppetlabs::lan
	include pkgs::admin
	include approx
	include apt-cacher

}
