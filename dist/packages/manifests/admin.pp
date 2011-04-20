class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
  ]

  package {
    $admin_pacakges: ensure => installed;
  }

}
