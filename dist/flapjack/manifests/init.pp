# Class: flapjack
#
# This class installs and configures Flapjack
#
# Parameters:
#
# Actions:
#   - Install beanstalkd
#   - Install flapjack
#
# Requires:
#   - EPEL
#
# Sample Usage:
#
class flapjack {
  require yum::epel
  require ruby::dev

  package { "beanstalkd":
    ensure   => installed,
  }

  package { "flapjack":
    ensure   => installed,
    provider => gem,
  }
}

