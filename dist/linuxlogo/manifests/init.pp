class linuxlogo { 
  include linuxlogo::params

  package { "$linuxlogo::params::linuxlogo_package": ensure => installed; }

}
