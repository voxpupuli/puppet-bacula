class puppetlabs::os::freebsd {

  $packages_to_install = [  'sysutils/tmux',
                            'sysutils/pv',
                            'sysutils/screen',
                            'ports-mgmt/portmaster',
                            'ports-mgmt/portupgrade',
                            'net/netcat',
                            'security/ca_root_nss',
                            'sysutils/lsof',
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
    require => Package['bash'],
  }

  file{ '/bin/zsh':
    ensure  => link,
    target  => '/usr/local/bin/zsh',
    require => Package['zsh'],
  }

  file { "/root/ports-supfile":
    source => "puppet:///modules/puppetlabs/ports-supfile",
  }

  cron { "update ports":
    minute  => 20,
    hour    => 20,
    user    => root,
    command => "/usr/bin/csup /root/ports-supfile > /dev/null || echo \$?",
  }

}
