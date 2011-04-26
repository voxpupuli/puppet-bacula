class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
    "keychain",
  ]

  package {
    "$admin_pacakges": ensure => installed;
  }

}
