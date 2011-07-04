# Class: ruby
#
# This class installs Ruby
#
# Parameters:
#
# Actions:
#   - Install Ruby
#   - Install Ruby Gems
#
# Requires:
#
# Sample Usage:
#
class ruby {
  include ruby::params

  if ! $kernel == "Darwin" {
    package{'ruby':
      ensure => installed,
    }
  }

  if $operatingsystem == "Linux" { # added to support non-linux
    package{'rubygems':
      ensure  => installed,
      require => Package['ruby'],
    }
  }
}
