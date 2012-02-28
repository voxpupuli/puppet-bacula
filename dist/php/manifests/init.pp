class php {

  include php::params

  package { $php::params::php_package:
    ensure => installed,
  }

}

