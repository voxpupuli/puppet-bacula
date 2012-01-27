class apache::mod::rack {
  require apache

  case $osfamily {
    'Debian': { $mod_rack_packages = 'libapache2-mod-passenger' }
    default: { fail("apache::mod::rack not supported on osfamily ${osfamily}") }
  }

  package { $mod_rack_packages:
    ensure => present,
  }
}
