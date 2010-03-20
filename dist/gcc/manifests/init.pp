# Class: gcc
#
# This class installs gcc
#
# Parameters:
#
# Actions:
#   - Install the gcc package
#   - Install the build-essential package
#
# Requires:
#
# Sample Usage:
#
class gcc {
  package{ [ "gcc", "build-essential" ]: 
    ensure => installed 
  }
}
