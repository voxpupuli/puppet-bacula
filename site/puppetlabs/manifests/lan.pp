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
  #include mailx
  #include postfix

#  case $operatingsystem {
#    "debian","ubuntu":  { 
#      class { "apt::settings": proxy => "http://vanir.puppetlabs.lan:3142" } 
#    }
#    default: { }
#  }

}
