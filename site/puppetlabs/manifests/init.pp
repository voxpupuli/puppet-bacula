class puppetlabs {
  #
  # This is our base install for all of our servers. 
  #  
  include ssh::servers
  include accounts
  include virtual-users 
  include virtual-groups
  include puppet::client
  include sudo
  Users <| tag == 'sysadmin' |>
  Users <| tag == 'sysadmin' |>
}
