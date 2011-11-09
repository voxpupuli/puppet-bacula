class packages::admin {
  
  $admin_packages = [
    "rsync",
    "htop",
    "screen",
    "tmux"
  ]

  package { $admin_packages: ensure => installed; }

  # This was only being used by site/puppetlabs/manifests/service/pkgrepo.pp
  # gpg stuff has been moved to its own module; if gpg-agent should be part of
  # this package loadout then you should do 'include gpg'
  #@package { "gnupg-agent": ensure => installed; }

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
