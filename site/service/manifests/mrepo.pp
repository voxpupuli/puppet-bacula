class service::mrepo {

  motd::register {'mrepo': }

  class { 'mrepo::params':
    rhn           => true,
    user          => "root",
    group         => "root",
    rhn_username  => 'puppetlabs',
    rhn_password  => 'yXgBdtwfEs',
  }

  # mirrors.cat.pdx.edu is down as of 1-11-2012
  # $centos_mirror = "http://mirrors.cat.pdx.edu"
  $centos_mirror = "http://mirrors.ecvps.com"
  $vault_mirror = "http://vault.centos.org"

  ##############################################################################
  # RHEL mirrors
  ##############################################################################

  mrepo::repo { "rhel6server-x86_64":
    ensure    => present,
    rhn       => true,
    repotitle => 'Red Hat Enterprise Linux Server $release ($arch) LATEST',
    arch      => "x86_64",
    release   => "6",
    rhnrelease => "6Server",
    hour      => 22,
    iso       => 'rhel-server-6.0-$arch-dvd.iso',
    urls      => {
      updates   => 'rhns:///rhel-$arch-server-$release',
      optional  => 'rhns:///rhel-$arch-server-optional-$release',
    },
  }

  mrepo::repo { "rhel6server-i386":
    ensure     => present,
    rhn        => true,
    repotitle  => 'Red Hat Enterprise Linux Server $release ($arch) LATEST',
    arch       => "i386",
    release    => "6",
    rhnrelease => "6Server",
    hour       => 23,
    iso        => 'rhel-server-6.0-$arch-dvd.iso',
    urls       => {
      updates   => 'rhns:///rhel-$arch-server-$release',
      optional  => 'rhns:///rhel-$arch-server-optional-$release',
    },
  }

  mrepo::repo { "rhel5server-x86_64":
    ensure     => present,
    rhn        => true,
    repotitle  => 'Red Hat Enterprise Linux Server $release ($arch) LATEST',
    arch       => "x86_64",
    release    => "5",
    rhnrelease => "5Server",
    hour       => 0,
    iso        => 'rhel-5-server-$arch-disc?.iso',
    urls       => {
      updates  => 'rhns:///rhel-$arch-server-5',
    },
  }

  mrepo::repo { "rhel5server-i386":
    ensure     => present,
    rhn        => true,
    repotitle  => 'Red Hat Enterprise Linux Server $release ($arch) LATEST',
    arch       => "i386",
    release    => "5",
    rhnrelease => "5Server",
    hour       => 1,
    iso        => 'rhel-5-server-$arch-disc?.iso',
    urls       => {
      updates  => 'rhns:///rhel-$arch-server-5',
    },
  }

  ##############################################################################
  # Latest CentOS mirrors
  ##############################################################################

  mrepo::repo { "cent5latestserver-x86_64":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch) LATEST',
    arch      => "x86_64",
    release   => "5",
    iso       => 'CentOS-5.7-$arch-bin-DVD-?of2.iso',
    hour      => 2,
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }

  mrepo::repo { "cent5latestserver-i386":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch) LATEST',
    arch      => "i386",
    release   => "5",
    iso       => 'CentOS-5.7-$arch-bin-DVD-?of2.iso',
    hour      => 3,
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }


  mrepo::repo { "cent6latestserver-i386":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch) LATEST',
    arch      => "i386",
    release   => "6",
    hour      => 6,
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }

  mrepo::repo { "cent6latestserver-x86_64":
    ensure    => present,
    repotitle => 'CentOS Linux $release ($arch) LATEST',
    arch      => "x86_64",
    release   => "6",
    hour      => 6,
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }

  ##############################################################################
  # CentOS 4 mirrors are also frozen since CentOS 4 is EOL
  ##############################################################################

  #This directory (and version of CentOS) is depreciated.
  #
  #CentOS-4 is now past EOL
  #
  #You can get the last released version of centos 4.9 here:
  #
  #http://vault.centos.org/4.9/


  mrepo::repo { "cent4latestserver-x86_64":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch) LATEST',
    arch      => "x86_64",
    release   => "4",
    update    => "never",
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }

  mrepo::repo { "cent4latestserver-i386":
    ensure    => present,
    repotitle => 'CentOS Enterprise Linux $release ($arch) LATEST',
    arch      => "i386",
    release   => "4",
    update    => "never",
    urls      => {
      os      => "$centos_mirror/centos/\$release/\$repo/\$arch/",
      updates => "$centos_mirror/centos/\$release/\$repo/\$arch/",
    },
  }

  ##############################################################################
  # CentOS static mirrors
  # These mirrors will need to be manually synced once after their generation
  # since they only need to fetch upstream once.
  ##############################################################################

  mrepo::repo { "cent50server-x86_64":
    ensure    => present,
    update    => "never",
    repotitle => 'CentOS Linux $release ($arch) FROZEN',
    arch      => "x86_64",
    release   => "5.0",
    iso       => 'CentOS-5.0-$arch-bin-DVD.iso',
    urls      => {
      updates => "$vault_mirror/\$release/updates/\$arch/",
    },
  }

  mrepo::repo { "cent50server-i386":
    ensure    => present,
    update    => "never",
    repotitle => 'CentOS Linux $release ($arch) FROZEN',
    arch      => "i386",
    release   => "5.0",
    iso       => 'CentOS-5.0-$arch-bin-DVD.iso',
    urls      => {
      updates => "$vault_mirror/\$release/updates/\$arch/",
    },
  }

  mrepo::repo { "cent40server-x86_64":
    ensure    => present,
    update    => "never",
    repotitle => 'CentOS Linux $release ($arch) FROZEN',
    arch      => "x86_64",
    release   => "4.0",
    iso       => 'CentOS-$release-$arch-bin?of4.iso',
    urls      => {
      updates => "$vault_mirror/\$release/updates/\$arch/",
    },
  }

  mrepo::repo { "cent40server-i386":
    ensure    => present,
    update    => "never",
    repotitle => 'CentOS Linux $release ($arch) FROZEN',
    arch      => "i386",
    release   => "4.0",
    iso       => 'CentOS-$release-$arch-bin?of4.iso',
    urls      => {
      updates => "$vault_mirror/\$release/updates/\$arch/",
    },
  }

  mrepo::repo { "sles-11-sp1-i386":
    ensure    => present,
    update    => "never",
    repotitle => 'SuSE Linux Enterprise Server SP1 i586 FROZEN',
    arch      => "i386",
    release   => "11",
    iso       => "SLE-11-SP1-SDK-DVD-i586-GM-DVD1.iso SLES-11-SP1-DVD-i586-GM-DVD?.iso",
  }

  mrepo::repo { "sles-11-sp1-x86_64":
    ensure    => present,
    update    => "never",
    repotitle => 'SuSE Linux Enterprise Server SP1 x86_64 FROZEN',
    arch      => "x86_64",
    release   => "11",
    iso       => "SLE-11-SP1-SDK-DVD-x86_64-GM-DVD1.iso SLES-11-SP1-DVD-x86_64-GM-DVD1.iso",
  }
}
