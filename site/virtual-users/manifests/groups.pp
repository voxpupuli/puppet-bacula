class virtual-users::groups {
  @group {'sysadmin':
    ensure => present,
    gid => 500,
  }
}
