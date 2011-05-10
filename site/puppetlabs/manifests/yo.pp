class puppetlabs::yo {

  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  class { 'mrepo::settings':
    rhn_username  => 'puppetlabs',
    rhn_password  => 'yXgBdtwfEs',
    isoroot       => '/var/mrepo/iso',
  }

  mrepo::repo { "rhel6s":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "i386 x86_64",
    release   => "6",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-6',
  }
  mrepo::repo { "rhel5.6s":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "i386 x86_64",
    release   => "5.6",
    iso       => 'rhel-server-5.6-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-5',
  }
}
