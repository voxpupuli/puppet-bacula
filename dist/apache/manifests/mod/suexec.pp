class apache::mod::suexec {

  case $operatingsystem {
    Debian: {
      package { 'apache2-suexec':
        ensure => present,
      }
      a2mod { 'suexec': ensure => present, }
    }
    default: {
      fail("${module_name} does not support operating system ${operatingsystem}")
    }
  }
}
