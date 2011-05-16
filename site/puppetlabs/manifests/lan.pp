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
  ssh::allowgroup { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  #include ntp
  #include mailx
  #include postfix
  include puppet
  include ssh::server
  include virtual::users 
  include sudo
  Account::User <| tag == 'allstaff' |>
  Group <| tag == 'allstaff' |>

#  case $operatingsystem {
#    "debian","ubuntu":  { 
#      class { "apt::settings": proxy => "http://vanir.puppetlabs.lan:3142" } 
#    }
#    default: { }
#  }

  

}
