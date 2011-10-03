class puppetlabs::os::linux::debian  {
  include puppetlabs::os::linux

  # This doesn't help at all, since the provider is actually adduser, not useradd
  # should be removed, class and module included
  #class { "useradd::settings":
  #  last_uid => '1099',
  #  last_gid => '1099',
  #}

  case $domain {
    "puppetlabs.lan": {
      # Setup apt settings specific to the lan
      class { "apt::settings": proxy => hiera("proxy"); }
    }
    "puppetlabs.com": {
    }
    default: { }
  }

  package {
    "lsb-release": ensure => installed;
    "keychain":    ensure => installed;
  }

  exec {
    "import puppet labs apt key":
      user    => root,
      command => "/usr/bin/wget -q -O - http://apt.puppetlabs.com/debian/4BD6EC30.asc | apt-key add -",
      unless  => "/usr/bin/apt-key list | grep -q 4BD6EC30",
      before  => Exec["apt-get update"];
    "apt-get update":
      user        => root,
      command     => "/usr/bin/apt-get -qq update",
      refreshonly => true;
  }

  file {
    "/etc/apt/sources.list.d/ops.list":
      ensure   => absent,
  }
  file {
    "/etc/apt/sources.list.d/puppetlabs.list":
      content => "deb http://apt.puppetlabs.com/debian squeeze main\n",
      #content  => "deb http://apt.puppetlabs.com/debian $lsbdistcodename main\n",
      notify   => Exec["apt-get update"],
  }

  cron { "apt-get update":
    command => "/usr/bin/apt-get -qq update",
    user    => root,
    minute  => 20,
    hour    => 1,
  }

}
