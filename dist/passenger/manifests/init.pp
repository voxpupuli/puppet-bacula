class passenger {
  include apache
  package{'passenger':
    name   => 'libapache2-mod-passenger',
    ensure => installed,
  }
}
