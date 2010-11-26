# Class: account::params
#
# This class contains the parameters for the account module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class account::params {

  case $operatingsystem {
    'ubuntu': {
      $mkpasswd = 'mkpasswd'
    }
    'centos': {
      $mkpasswd = 'expect'
    }
  }
}
