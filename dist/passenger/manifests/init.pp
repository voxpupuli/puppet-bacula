class passenger {
  include passenger::params
  include ruby::dev
  include gcc
  include apache::dev
  $version=$passenger::params::version
  package{'passenger':
    name   => 'passenger',
    ensure => $version,
    provider => 'gem',
  }
  exec{'compile-passenger':
    path => ['/usr/bin', '/bin'],
    command => 'passenger-install-apache2-module -a',
    logoutput => true,
    # this creates path doesnt seem very general
    creates => "/usr/lib/ruby/gems/1.8/gems/passenger-${version}/ext/apache2/mod_passenger.so",
  }
}
