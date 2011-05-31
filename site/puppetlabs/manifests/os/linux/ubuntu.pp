class puppetlabs::os::linux::ubuntu {

  class { "useradd::settings":
    last_uid => '1099',
    last_gid => '1099',
  }

  package {
    "lsb-release": ensure => installed; 
    "keychain":    ensure => installed; 
  }

  exec {
    "import puppet labs apt key":
      user    => root,
      command => "/usr/bin/wget -q -O - http://apt.puppetlabs.com/ops/4BD6EC30.asc | apt-key add -",
      unless  => "/usr/bin/apt-key list | grep -q 4BD6EC30",
      before  => Exec["apt-get update"];
    "apt-get update":
      user => root,
      command => "/usr/bin/apt-get -qq update",
      refreshonly => true;
  }

  file {
    "/etc/apt/sources.list.d/ops.list": 
      content => "deb http://apt.puppetlabs.com/ops sid main\n",
      notify => Exec["apt-get update"];
  }

}

