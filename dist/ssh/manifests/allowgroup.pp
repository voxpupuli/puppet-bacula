define ssh::allowgroup ($chroot=false, $tcpforwarding=false) {

  include ssh::params
  include ssh::server

  $sshd_config = $ssh::params::sshd_config

  if $chroot == true {
  include ssh::chroot
    file {
      "/var/chroot/${name}": ensure => directory, owner => root, group => root, mode => 755;
      "/var/chroot/${name}/drop": ensure => directory, owner => root, group => $name, mode => 775;
    }
    if $tcpforwarding == true {
      $sshd_config_content = "Match group ${name}\n\t ChrootDirectory /var/chroot/${name}\n\t AllowTcpForwarding yes\n\t ForceCommand internal-sftp\n"
    }
    else {
      $sshd_config_content = "Match group ${name}\n\t ChrootDirectory /var/chroot/${name}\n\t AllowTcpForwarding no\n\t ForceCommand internal-sftp\n"
    }
    concat::fragment { "sshd_config_chroot_group-${name}":
      target => "$sshd_config",
      content => $sshd_config_content,
    }
  }

  concat::fragment { "sshd_config_AllowGroups-${name}":
    target => "$sshd_config",
    content => "AllowGroups ${name}\n",
  }

}

