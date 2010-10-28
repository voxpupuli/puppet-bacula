class pxe {
	include pxe::params
	include apache

	$tftp_root = $pxe::params::tftp_root
	$ks_root   = $pxe::params::ks_root

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
		"${tftp_root}": ensure => directory, owner => root, group => root, mode => 755;
		"${tftp_root}/pxelinux.0": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/pxelinux.0";
		"${tftp_root}/menu.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/menu.c32";
		"${tftp_root}/memdisk": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/memdisk";
		"${tftp_root}/mboot.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/mboot.c32";
		"${tftp_root}/chain.c32": ensure => directory, owner => root, group => root, mode => 755,
			source => "/usr/lib/syslinux/chain.c32";
		#"${tftp_root}/pxelinux.cfg": ensure => directory, owner => root, group => root, mode => 755;
		"${tftp_root}/images":										ensure => directory, owner => root, group => root, mode => 755;
		"${tftp_root}/images/centos":						ensure => directory, owner => root, group => root, mode => 755;
		"${ks_root}": ensure => directory, owner => root, group => root, mode => 755;
	}

	service {
		"xinetd":
			ensure => running,
			enable => true;
	}
	
	$dirs = [
		"${tftp_root}/images/centos/i386",
		"${tftp_root}/images/centos/x86_64",
	]
	
	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }
	
	#fragment { "cent-header":
  #  order => '00',
  #  path => "${tftp_root}/pxelinux.cfg",
  #  target => 'cent',
  #  source => 'puppet:///modules/pxe/centosPXE-header',
  #}

  #fragment::concat { 'cent':
  #  owner => 'root',
  #  group => 'root',
  #  mode => '0644',
  #  path => "${tftp_root}/pxelinux.cfg",
  #}

	centosimages { 
		"centos_i386_4.8":
			arch => "i386",
			ver => "4.8";
		"centos_x86_64_4.8":
			arch => "x86_64",
			ver => "4.8";
		"centos_i386_5.5":
			arch => "i386",
			ver => "5.5";
		"centos_x86_64_5.5":
			arch => "x86_64",
			ver => "5.5";
	}
	
}

define centosimages($arch,$ver) {
	
	$dirs = [
		"${tftp_root}/images/centos/${arch}/${ver}",
	]

	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }

	exec {
		"pull centos pxe vmlinuz $arch $ver":
			cwd => "${tftp_root}/images/centos/${arch}/${ver}",
			command => "/usr/bin/wget http://mirrors.kernel.org/centos/${ver}/os/${arch}/images/pxeboot/vmlinuz",
			creates => "${tftp_root}/images/centos/${arch}/${ver}/vmlinuz";
		"pull centos pxe initrd.img $arch $ver":
			cwd => "${tftp_root}/images/centos/${arch}/${ver}",
			command => "/usr/bin/wget http://mirrors.kernel.org/centos/${ver}/os/${arch}/images/pxeboot/initrd.img",
			creates => "${tftp_root}/images/centos/${arch}/${ver}/initrd.img";
	}

	file {
		"${ks_root}/centos_${arch}_${ver}.cfg":
			owner => root, group => root, mode => 644, content => template("pxe/centos_ks.cfg.erb");
	}

  #fragment{ "cent-${title}":
  #  filename   => "${tftp_root}/pxelinux.cfg/cent",
  #  content    => template("pxe/centosPXE-entry"),
  #}


}

