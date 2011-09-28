class puppetlabs::os::freebsd {

  $packages_to_install = [  'sysutils/tmux',
                            'sysutils/pv',
                            'net/netcat',
                            'sysutils/lsof',
                            'editors/vim-lite' ]

  # Install some basic packages. Nothing too spicy.
  package{ $packages_to_install:
    ensure   => present,
    # provider => freebsd,
  }

}
