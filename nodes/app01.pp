node app01 {
  include role::server
  include patchwork

  ssh::allowgroup { "developers": }
  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }

  ####
  # Bacula
  #
  $bacula_director = 'bacula01.puppetlabs.lan'
  $bacula_password = 'BxDEBcLjB7gOG22QZrVzHTVx9kaDsVhkYIqEHuTCzzKJ9ryTFlpEulJNj29URHb'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  # https://projects.puppetlabs.com/issues/7849
  # github pull request robot
  # THIS DOESN'T WORK, VCSREPO IS UTTER MONKEY SHIT.
  class{ 'githubrobotpuller':
    version => 'bd4ea8f52b66556a1d45c03f9ff975e09f6b16e2',
  }

}
