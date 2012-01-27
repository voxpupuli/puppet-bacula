class apache::mod::passenger {
  require apache

  case $osfamily {
    'Debian': { $mod_passenger_packages = 'libapache2-mod-passenger' }
    default: { fail("apache::mod::passenger not supported on osfamily ${osfamily}") }
  }

  package { $mod_passenger_packages:
    ensure => present,
  }

  a2mod { "passenger": ensure => present }
}
