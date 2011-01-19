define ssh::allowgroup ($chroot=false) {

	if $chroot == true {
	include ssh::chroot
		file {
			"/var/chroot/${name}": ensure => directory;
		}
		concat::fragment { "sshd_config_chroot_group-${name}":
		  target => "/etc/ssh/sshd_config",
			content => "Match group ${name}\n\t ChrootDirectory /var/chroot/${name}\n\t AllowTcpForwarding no\n\t ForceCommand internal-sftp\n";
		}
	}

	concat::fragment { "sshd_config_AllowGroups-${name}":
	  target => "/etc/ssh/sshd_config",
	  content => "AllowGroups ${name}\n",
	}

}

