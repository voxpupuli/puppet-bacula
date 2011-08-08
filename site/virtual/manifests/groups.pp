class virtual::groups {

 # use 600 - 999 for groups

  @group { 'allstaff':
    ensure => present,
    gid    => 600,
  }
  @group { 'techops':
    ensure => present,
    gid    => 601,
  }
  @group { 'sysadmin':
    ensure => present,
    gid    => 666,
  }
  @group { 'developers':
    ensure => present,
    gid    => 667,
  }
  @group { 'prosvc':
    ensure => present,
    gid    => 668,
  }
  @group { 'operations':
    ensure => present,
    gid    => 673,
  }
  @group { 'git':
    ensure => present,
    gid    => 674,
  }
  @group { 'enterprise':
    ensure => present,
    gid    => 675,
  }
  @group { 'release':
    ensure => present,
    gid    => 676,
  }
  @group { 'interns':
    ensure => present,
    gid    => 677,
  }
  @group { 'www-dev': # web developers
    ensure => present,
    gid    => 678,
  }
  @group { 'contractors':
    ensure => present,
    gid    => 679,
  }
  @group { 'builder': # Package Builders
    ensure => present,
    gid    => 680,
  }



#
# Service Groups
#
  @group { 'hudson':
    ensure => present,
    gid    => 620,
  }

  @group { 'osqa':
    ensure => present,
    gid    => 621,
  }

  @group { 'patchwork':
    ensure => present,
    gid    => 622,
  }

#
# Customers
# 1050 - 2000

  @group { 'vmware':
    ensure => present,
    gid    => 1050,
    tag    => customer,
  }

  @group { 'motorola':
    ensure => present,
    gid    => 1051,
    tag    => customer,
  }

  @group { 'nokia':
    ensure => present,
    gid    => 1052,
    tag    => customer,
  }

  @group { 'blackrock':
    ensure => present,
    gid    => 1053,
    tag    => customer,
  }

  @group { 'secureworks':
    ensure => present,
    gid    => 1054,
    tag    => customer,
  }

  @group { 'bioware':
    ensure => present,
    gid    => 1055,
    tag    => customer,
  }

  @group { 'wealthfront':
    ensure => present,
    gid    => 1056,
    tag    => customer,
  }

  @group { 'advance':
    ensure => present,
    gid    => 1057,
    tag    => customer,
  }


#
# Functional
#


}

