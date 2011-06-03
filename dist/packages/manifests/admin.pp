class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
    "tmux"
  ]

  package { $admin_packages: ensure => installed; }


  # OS specific/named specific packages.
  case $operatingsystem {
    'ubuntu': {
      package { [ 'ack-grep' ]:
        ensure => installed
      }
    }
    'debian': {
      package { [ 'locales-all' , 'ack-grep' ]:
        ensure => installed
      }
    }
    'centos': {
      # package{ debian : ensure => reboot_and_install }
    }
  }

}
