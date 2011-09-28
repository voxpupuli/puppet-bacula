class puppetlabs::os::freebsd {

  # Install some basic packages. Nothing too spicy.
  package{ [ 'tmux', 'pv', 'netcat', 'lsof', 'vim-lite']:
    ensure   => present,
    # provider => freebsd,
  }

}
