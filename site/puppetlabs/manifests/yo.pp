class puppetlabs::yo {

  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  class { 'mrepo::settings':
    rhn_username  => 'puppetlabs',
    rhn_password  => 'yXgBdtwfEs',
    isoroot       => '/var/mrepo/iso',
  }

  mrepo::repo { "6server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => "RHEL server 6 64 bit",
    arch      => "x86_64",
    release   => "6Server",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-6',
  }
  mrepo::repo { "6server-i386":
    ensure    => present,
    rhn       => true,
    repotitle => "RHEL server 6 32 bit",
    arch      => "i386",
    release   => "6Server",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-6',
  }
  mrepo::repo { "5server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => "RHEL server 5 64 bit",
    arch      => "x86_64",
    release   => "5Server",
    iso       => 'rhel-server-5.5-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-5',
  }
  mrepo::repo { "5server-i386":
    ensure    => present,
    rhn       => true,
    repotitle => "RHEL server 5 32 bit",
    arch      => "i386",
    release   => "5Server",
    iso       => 'rhel-server-5.5-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-5',
  }
}
