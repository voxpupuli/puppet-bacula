class os::freebsd {

  if $haszfs == true {
    include zfs
    include zfs::snapshots
  }

  #Package { source => "http://ftp4.freebsd.org/pub/FreeBSD/ports/${architecture}/packages-${kernelmajversion}-release/", provider => portupgrade }
  Package { provider => portupgrade }

  $packages_to_install = [  'sysutils/tmux',
                            'sysutils/pv',
                            'sysutils/screen',
                            'ports-mgmt/portmaster',
                            'ports-mgmt/portupgrade',
                            'net/netcat',
                            'security/ca_root_nss',
                            'sysutils/lsof',
                            'sysutils/smartmontools',
                            'textproc/p5-ack',
                            'editors/vim-lite' ]

  # Install some basic packages. Nothing too spicy.
  package{ $packages_to_install:
    ensure   => present,
    # provider => freebsd,
  }

  package {
    "ports-mgmt/portaudit":
      ensure => installed,
      notify => Exec["/usr/local/sbin/portaudit -Fda"];
  }

  exec {
    "/usr/local/sbin/portaudit -Fda":
      user        => root,
      refreshonly => true;
  }

  # This is horrible, but it stops a lot of things breaking (concat for example)
  file{ '/bin/bash':
    ensure  => link,
    target  => '/usr/local/bin/bash',
  }

  file{ '/bin/zsh':
    ensure  => link,
    target  => '/usr/local/bin/zsh',
  }

  # This just makes our lives easier.
  file{ '/etc/puppet':
    ensure  => link,
    target  => '/usr/local/etc/puppet',
  }

  file{ '/usr/bin/ruby':
    ensure => link,
    target => '/usr/local/bin/ruby',
  }


  # See http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/cvsup.html#CVSUP-MIRRORS
  $csuphostnum = fqdn_rand( 16 )
  $csuphost    = "cvsup${csuphostnum}.freebsd.org"
  file {
    '/etc/ports-supfile':
      content => template( "puppetlabs/ports-supfile.erb" ),
      owner   => 'root',
      mode    => '0444';
    "/root/ports-supfile":
      ensure => absent;
  }

  cron { "update ports":
    minute  => fqdn_rand( 60 ),
    hour    => 20,
    user    => root,
    command => "/usr/bin/csup -l /var/run/csup.lockfile -L 0 -z /etc/ports-supfile",
  }


  # Set periodic, so we can control a bit more what we get emailed
  # about.
  file{ '/etc/periodic.conf':
    ensure => file,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/os/freebsd/periodic.conf',
  }

}
