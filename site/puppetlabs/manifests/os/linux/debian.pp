class puppetlabs::os::linux::debian  {
  include puppetlabs::os::linux

  include harden

  case $domain {
    "puppetlabs.lan": {
      # Setup apt settings specific to the lan
      class { "apt::settings": proxy => hiera("proxy"); }
    }
    "puppetlabs.com": {
    }
    default: { }
  }

  $packages = [
    'lsb-release',
    'keychain',
    'ca-certificates',
  ]

  package { $packages: ensure => latest; }

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

  cron { "apt-get update":
    command => "/usr/bin/apt-get -qq update",
    user    => root,
    minute  => 20,
    hour    => 1,
  }

  # For some reason, we keep getting mpt installed on things. Not
  # cool.
  if $is_virtual == 'true' {
    package{ 'mpt-status':
      ensure => purged,
    }
  }

  # Once facter is included in the /debian repo, the /ops repo can be removed
  apt::source { "puppetlabs_ops.list":
    uri          => "http://apt.puppetlabs.com/ops",
    distribution => "sid"
  }

  case $operatingsystem {
    Debian: {
      apt::source { "puppetlabs.list":
        uri          => "http://apt.puppetlabs.com/debian",
      }
      apt::source { "main.list": }
      apt::source { "security.list":
        uri          => "http://security.debian.org/",
        distribution => "squeeze/updates"
      }
      apt::source { "updates.list":
        uri          => "http://ftp.us.debian.org/debian/",
        distribution => "squeeze-updates"
      }
    }
    default: { }
  }

}

