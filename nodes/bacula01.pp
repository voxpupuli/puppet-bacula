node bacula01 {
  include role::server

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
}

