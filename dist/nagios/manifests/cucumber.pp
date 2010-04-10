# Class: nagios::cucumber
#
# This class installs and configures Cucumber to use with Nagios
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::cucumber {

  package { "cucumber-nagios":
    ensure => present,
    provider => gem,
  }

}
