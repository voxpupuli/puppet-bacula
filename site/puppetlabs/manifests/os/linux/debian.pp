class puppetlabs::os::linux::debian {

  package { 
    "lsb-release": ensure => installed; 
    "keychain":    ensure => installed; 
  }

}
