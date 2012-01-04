# = Node: tupac
#
# == Description
#
# Hosts OSX VMs
node tupac {
  include role::base
  include virtual::users
  include motd

  Account::User <| tag = sysadmin |>
  ssh::allowgroup { "sysadmin": }
  sudo::allowgroup { "sysadmin": }
}

