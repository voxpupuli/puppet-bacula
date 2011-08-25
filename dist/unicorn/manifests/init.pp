class unicorn {

  require ruby

  package {
    'unicorn': ensure => installed, provider => gem;
  }

}

