node bacula01 {
  include role::server
  include role::gearman

  ssh::allowgroup  { "techops": }
  sudo::allowgroup { "techops": }

  ####
  # Duplicity
  #
  class { 'duplicity::params':
    droproot => "/bacula/duplicity",
  }

  include duplicity::ssh_server

  duplicity::drop { "git.puppetlabs.net":
    owner => "gitbackups"
  }

  include sysctl
  Sysctl {
    notify => Exec[load-sysctl]
  }
  sysctl { "vm.swappiness": val => '25'; }

}

