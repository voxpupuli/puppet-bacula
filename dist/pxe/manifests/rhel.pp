define pxe::rhel($arch,$ver) {
	
	$dirs = [
		"${tftp_root}/images/rhel/${arch}/${ver}",
	]

	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }

	exec {
		"pull rhel pxe vmlinuz $arch $ver":
			cwd => "${tftp_root}/images/rhel/${arch}/${ver}",
			command => "/usr/bin/wget http://mirrors.kernel.org/rhel/${ver}/os/${arch}/images/pxeboot/vmlinuz",
			creates => "${tftp_root}/images/rhel/${arch}/${ver}/vmlinuz";
		"pull rhel pxe initrd.img $arch $ver":
			cwd => "${tftp_root}/images/rhel/${arch}/${ver}",
			command => "/usr/bin/wget http://mirrors.kernel.org/rhel/${ver}/os/${arch}/images/pxeboot/initrd.img",
			creates => "${tftp_root}/images/rhel/${arch}/${ver}/initrd.img";
	}

	file {
		"${ks_root}/rhel_${arch}_${ver}.cfg":
			owner => root, group => root, mode => 644, content => template("pxe/rhel_ks.cfg.erb");
	}


}

