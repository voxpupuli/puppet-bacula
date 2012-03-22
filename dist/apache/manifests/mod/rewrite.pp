class apache::mod::rewrite {

  case $operatingsystem {
    Debian: { a2mod { 'rewrite': ensure => present, } }
    default: { fail("${module_name} does not support operating system ${operatingsystem}") }
  }
}
