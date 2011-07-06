class puppetlabs::service::mrepo {

  class { 'mrepo::params':
    rhn           => true,
    user          => "root",
    group         => "root",
    rhn_username  => 'puppetlabs',
    rhn_password  => 'yXgBdtwfEs',
  }

  mrepo::repo { "rhel6server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "x86_64",
    release   => "6",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    urls      => {
      updates   => 'rhns:///rhel-$arch-server-$release',
      optional  => 'rhns:///rhel-$arch-server-optional-$release',
    },
  }

  mrepo::repo { "rhel6server-i386":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch)',
    arch      => "i386",
    release   => "6",
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    urls      => {
      updates   => 'rhns:///rhel-$arch-server-$release',
      optional  => 'rhns:///rhel-$arch-server-optional-$release',
    },
  }

  mrepo::repo { "cent5server-x86_64":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch)',
    arch      => "x86_64",
    release   => "5",
    iso       => 'CentOS-5.6-$arch-bin-DVD-?of2.iso',
    urls      => {
      updates => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
    },
  }
  mrepo::repo { "cent5server-i386":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch)',
    arch      => "i386",
    release   => "5",
    iso       => 'CentOS-5.6-$arch-bin-DVD.iso',
    urls      => {
      updates => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
    },
  }

  mrepo::repo { "cent4server-x86_64":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "x86_64",
    release   => "4",
    iso       => 'CentOS-4.0-$arch-bin?of4.iso',
    urls      => {
      updates => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
    },
  }
  mrepo::repo { "cent4server-i386":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch)',
    arch      => "i386",
    release   => "4",
    iso       => 'CentOS-4.0-$arch-bin?of4.iso',
    urls      => {
      updates => 'rsync://mirrors.kernel.org/centos/$release/updates/$arch/',
    },
  }
}
