class vmware::tools::debian {

    apt::source{ 'contrib.list':
      uri       => 'http://ftp.us.debian.org/debian',
      component => 'contrib'
    }

    package {
      'open-vm-tools':
        require => Apt::Source['contrib.list'],
        ensure  => installed;
      'open-vm-source':
        require => Apt::Source['contrib.list'],
        ensure  => installed;
      'module-assistant':
        require => Apt::Source['contrib.list'],
        ensure  => installed;
    }

    exec{ 'module-assistant auto-install open-vm -i':
      user     => 'root',
      path     => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin',
      creates  => "/lib/modules/${kernelreleasea}/misc/vmmemctl.ko",
      require  => [ Package['open-vm-tools'], Package['open-vm-source'], Package['module-assistant'] ],
    }

}
