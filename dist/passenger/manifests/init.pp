class passenger {
  include ruby::dev
  include gcc
  include apache::dev
  package{'passenger':
    name   => 'passenger',
    ensure => installed,
    provider => 'gem',
  }
  exec{'compile-passenger':
    path => ['/usr/bin', '/bin'],
    command => 'passenger-install-apache2-module -a',
    logoutput => true,
    # this creates path doesnt seem very general
    creates => '/usr/lib/ruby/gems/1.8/gems/passenger-2.2.11/ext/apache2/mod_passenger.so',
  }
}
