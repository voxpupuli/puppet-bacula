class unicorn {

  include ruby

  package {
    'unicorn': ensure => installed, provider => gem;
  }

}

