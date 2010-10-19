class pxe {
	include pxe::params
	include apache

	package {
		"xinetd":				ensure => installed;
		"syslinux":			ensure => installed;
		"tftp-server":	ensure => installed;
	}

	file {
		"/etc/xinetd.d/tftp":
			owner		=> root,
			group		=> root,
			mode		=> 644,
			notify	=> Service["xinetd"],
			source	=> "puppet:///modules/pxe/tftp_xinetd";
		"/tftpboot": ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/pxelinux.0": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/pxelinux.0";
		"/tftpboot/menu.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/menu.c32";
		"/tftpboot/memdisk": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/memdisk";
		"/tftpboot/mboot.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/mboot.c32";
		"/tftpboot/chain.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/chain.c32";
		"/tftpboot/pxelinux.cfg": ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images":										ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images/centos":						ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images/centos/x86":				ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images/centos/x86/5.5":		ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images/centos/x86_64":			ensure => directory, owner => root, group => root, mode => 755;
		"/tftpboot/images/centos/x86_64/5.5":	ensure => directory, owner => root, group => root, mode => 755;
		"/var/www/html/ks": ensure => directory, owner => root, group => root, mode => 755;
	}

	service {
		"xinetd":
			ensure => running,
			enable => true;
	}

}
