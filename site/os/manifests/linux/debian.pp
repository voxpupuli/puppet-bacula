class os::linux::debian  {

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
    'less',
  ]

  package { $packages: ensure => latest; }

  exec {
    "import puppet labs apt key":
      user    => root,
      command => "/usr/bin/wget -q -O - http://apt.puppetlabs.com/debian/pubkey.gpg | /usr/bin/apt-key add -",
      unless  => "/usr/bin/apt-key list | grep -q 4BD6EC30",
      before  => Exec["apt-get update"];
  }

  # For some reason, we keep getting mpt installed on things. Not
  # cool.
  if $is_virtual == 'true' {
    package{ 'mpt-status':
      ensure => purged,
    }
  }

  # ----------
  # Apt Configuration
  # ----------
  apt::conf {
    "norecommends":
      priority => '00',
      content  => "Apt::Install-Recommends 0;\nApt::AutoRemove::InstallRecommends 1;\n",
  }

  cron { "apt-get update":
    ensure  => $apt_get_update_ensure,
    command => "/usr/bin/apt-get -qq update",
    user    => root,
    minute  => 20, 
    hour    => 1,
  }

  # ----------
  # Apt Repo Sources
  # ----------
  apt::source {
    "security.list":
      uri       => $lsbdistid ? {
        "debian" => "http://security.debian.org/",
        "ubuntu" => "http://security.ubuntu.com/ubuntu",
      },
      distribution => $lsbdistid ? {
        "debian" => "${lsbdistcodename}/updates",
        "ubuntu" => "${lsbdistcodename}-security",
      },
      component => $lsbdistid ? {
        "debian" => "main",
        "ubuntu" => "main universe",
      },
  }

  apt::source { "puppetlabs.list": uri => "http://apt.puppetlabs.com/", }

  apt::pin { "puppetlabs":
    origin   => "apt.puppetlabs.com",
    priority => '900',
    wildcard => true,
  }

  apt::source { "updates.list":
    uri          => $lsbdistid ? {
      "debian" => "http://ftp.us.debian.org/debian/",
      "ubuntu" => "http://us.archive.ubuntu.com/ubuntu/",
    },
    distribution => "${lsbdistcodename}-updates",
    component    => $lsbdistid ? {
      "debian" => "main",
      "ubuntu" => "universe",
    },
  }



  # Debian Specific things
  case $operatingsystem {
    Debian: {
      apt::source { "main.list": }
      apt::source { "main_source.list": source_type => "deb-src"; }
    }
    default: { }
  }

  # We want backports, this doesn't pin anything, just throws the
  # option of it being there in (and pins for auto-updating, as
  # reccomended).
  include apt::backports


}

