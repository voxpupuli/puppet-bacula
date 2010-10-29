class puppetlabs::urd {
	include pkgs::admin
	#include yumrepo::mirror
	include yum::mirror
	include pxe

}
