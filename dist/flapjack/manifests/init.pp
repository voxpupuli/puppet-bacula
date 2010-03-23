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
#
# Sample Usage:
#
class flapjack {
  require ruby::dev
  include flapjack::params

  package { "beanstalkd":
    ensure   => installed,
  }

  package { "flapjack":
    ensure   => installed,
    provider => gem,
  }

  service { [ "flapjack-notifier", "flapjack-workers" ]:
    ensure => running,
    enable => true,
  }
}

