# = Node: clippy
#
# == Description
#
# This host provides a general purpose gitolite instance with secure backups.
#
# To view accessible git repositories, run `ssh git@git.puppetlabs.net info`
#
# == Other names
#
# - git.puppetlabs.lan
# - git.puppetlabs.net
node clippy {
  include role::server
  include service::gitolite

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

}
