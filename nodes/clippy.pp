# clippy, aka git.puppetlabs.net
#
# Hosts gitolite for github mirrors as well as puppetlabs private repos.

node clippy {
  include role::server
  include puppetlabs::service::gitolite

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

  # Required for encrypted backups of gitolite
  package { "duplicity":
    ensure => present
  }
}

