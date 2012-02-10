class linuxlogo {
  include linuxlogo::params

  if $operatingsystem != 'SLES' {
    package { "$linuxlogo::params::linuxlogo_package": ensure => installed; }
  }

}
