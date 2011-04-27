class puppetlabs::os::linux::ubuntu {

  package { 
    "lsb-release": ensure => installed; 
    "keychain":    ensure => installed; 
  }

  exec { 
    "import puppet labs apt key":
      user    => root,
      command => "/usr/bin/wget -q -O - http://apt.puppetlabs.com/ops/4BD6EC30.asc | apt-key add -",
      unless  => "/usr/bin/apt-key list | grep -q 4BD6EC30",
  }

}

