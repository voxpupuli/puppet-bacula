class pkgrepo {
  file { '/var/packages': ensure => directory, recurse => true, purge => true } 
}
