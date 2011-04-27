class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
  ]

  package { $admin_packages: ensure => installed; }

}
