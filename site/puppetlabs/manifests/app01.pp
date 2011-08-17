class puppetlabs::app01 {
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
    monitor  => false,
  }

  # https://projects.puppetlabs.com/issues/7849
  # github pull request robot
  # THIS DOESN'T WORK, VCSREPO IS UTTER MONKEY SHIT.
  class{ 'githubrobotpuller':
    version => 'ab2f4d7621a963f648c028cc4ed2f281f62a2311',
  }

}
