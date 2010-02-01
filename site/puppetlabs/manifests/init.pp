class puppetlabs {
  #
  # This is our base install for all of our servers. 
  #  
  include ssh::server
  include virtual::users 
  include sudo
  Account::User <| tag == 'sysadmin' |>
  Group <| tag == 'sysadmin' |>
}
