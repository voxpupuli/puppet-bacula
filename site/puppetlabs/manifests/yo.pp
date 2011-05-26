class puppetlabs::yo {

  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  class { 'mrepo::settings':
    rhn_username  => 'puppetlabs',
    rhn_password  => 'yXgBdtwfEs',
    isoroot       => '/var/mrepo/iso',
  }

  mrepo::repo { "rhel6server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "x86_64",
    release   => "6",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-$release',
  }

  mrepo::repo { "rhel6server-i386":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "i386",
    release   => "6",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    updates   => 'rhns:///rhel-$arch-server-$release',
  }

  mrepo::repo { "rhel5server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "x86_64",
    release   => "5",
    iso       => 'rhel-5-server-$arch-disc?.iso',
    updates   => 'rhns:///rhel-$arch-server-5',
  }

  mrepo::repo { "rhel5server-i386":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "i386",
    release   => "5",
    iso       => 'rhel-5-server-$arch-disc?.iso',
    updates   => 'rhns:///rhel-$arch-server-5',
  }

  mrepo::repo { "cent5server-x86_64":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "x86_64",
    release   => "5",
    iso       => 'rhel-server-5.0-$arch-dvd.iso',
    updates   => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
  }
  mrepo::repo { "cent5server-i386":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "i386",
    release   => "5",
    iso       => 'rhel-server-5.0-$arch-dvd.iso',
    updates   => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
  }

  mrepo::repo { "cent4server-x86_64":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "x86_64",
    release   => "4",
    iso       => 'CentOS-4.0-$arch-bin?of4.iso',
    updates   => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
  }
  mrepo::repo { "cent4server-i386":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "i386",
    release   => "4",
    iso       => 'CentOS-4.0-$arch-bin?of4.iso',
    updates   => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
  }
}
