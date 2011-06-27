class puppetlabs::app01 {
  include patchwork

  ssh::allowgroup { "developers": }

  ####
  # Bacula
  #
  $bacula_director = 'bacula01.puppetlabs.lan'
  $bacula_password = 'BxDEBcLjB7gOG22QZrVzHTVx9kaDsVhkYIqEHuTCzzKJ9ryTFlpEulJNj29URHb'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

}
