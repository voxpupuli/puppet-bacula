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

  if $kernel == "Linux" { # added to support non-linux
    package{
      'ruby':     ensure => installed;
      'rubygems': ensure => installed;
    }
  }
}
