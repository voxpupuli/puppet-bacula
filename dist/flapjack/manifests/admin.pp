# Class: flapjack::admin
#
# This class installs and configures Flapjack's Admin interface
#
# Parameters:
#
# Actions:
#   - Installs packages
#
# Requires:
#
# Sample Usage:
#
class flapjack::admin {
  include flapjack

  package { $flapjack::params::flapjack_admin_packages:
    ensure   => installed,
  }

}

