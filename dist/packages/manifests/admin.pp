class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
    "tmux"
  ]

  package { $admin_packages: ensure => installed; }


  # debian/ubuntu named specific packages.
  case $operatingsystem {
    'ubuntu', 'debian': {
      package { [ 'locales-all' , 'ack-grep' ]:
        ensure => installed
      }
    }
  }

}
