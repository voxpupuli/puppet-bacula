# Class: puppetlabs::lan
#
# This class installs and configures the Puppet Labs base classes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::lan {
  #
  # This is our base install for all of our servers. 
  #  
  #include ntp
  include puppet
  #include mailx
  #include postfix
  include ssh::server
  include virtual::users 
  include sudo
  Account::User <| tag == 'sysadmin' |>
  Group <| tag == 'sysadmin' |>
}
