class vmware::tools::debian {

    apt::source{ 'contrib':
      uri       => 'http://ftp.us.debian.org/debian',
      component => 'main contrib'
    }

    package {
      'open-vm-tools':
        require => Apt::Source['contrib'],
        ensure  => installed;
      'open-vm-source':
        require => Apt::Source['contrib'],
        ensure  => installed;
      'module-assistant':
        require => Apt::Source['contrib'],
        ensure  => installed;
    }

    exec{ 'module-assistant auto-install open-vm -i':
      user     => 'root',
      path     => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin',
      creates  => "/lib/modules/${kernelreleasea}/misc/vmmemctl.ko",
      requires => [ Package['open-vm-tools'], Package['open-vm-source'], Package['module-assistant'] ],
    }

}
