class passenger {
  include apache
  include ruby-dev
  # include gcc
  # include gplusplus
  # apache-dev
  # apr, apu
  package{'passenger':
    name   => 'passenger',
    ensure => installed,
    provider => 'passenger',
  }
#  exec{'compile-passenger':
#    path => 
#  }
}
