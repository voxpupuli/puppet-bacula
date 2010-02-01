class virtual::groups {
  @group {'sysadmin':
    ensure => present,
    gid => 666,
  }
}
