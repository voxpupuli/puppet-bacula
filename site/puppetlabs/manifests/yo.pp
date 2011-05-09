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
}
