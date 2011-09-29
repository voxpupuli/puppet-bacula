class puppetlabs::os::freebsd {

  $packages_to_install = [  'sysutils/tmux',
                            'sysutils/pv',
                            'shells/bash',
                            'shells/zsh',
                            'net/netcat',
                            'sysutils/lsof',
                            'editors/vim-lite' ]

  # Install some basic packages. Nothing too spicy.
  package{ $packages_to_install:
    ensure   => present,
    # provider => freebsd,
  }

  # This is horrible, but it stops a lot of things breaking (concat for example)
  file{ '/bin/bash':
    ensure  => link,
    target  => '/usr/local/bin/bash',
    require => Package['shells/bash'],
  }

}
