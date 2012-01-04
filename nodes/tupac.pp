# = Node: tupac
#
# == Description
#
# Hosts OSX VMs
node tupac {
  include role::base
  include virtual::users
  include motd

  Account::User <| groups == 'sysadmin' |>
  Group <| name == 'allstaff' |>
  ssh::allowgroup { "sysadmin": }
  sudo::allowgroup { "sysadmin": }
}

