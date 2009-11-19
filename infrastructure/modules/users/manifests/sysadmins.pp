class users::sysadmins {
  include users
  include sudo
  $my_sysadmins = ['dan', 'teyo', 'luke']
  group{'sysadmin':
    ensure => present
  }
  @user{$my_sysadmins:
    
  }
}
