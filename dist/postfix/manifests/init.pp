# Class: postfix
#
# This class installs and configures parameters for Postfix
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postfix {
  package { 'postfix':
    ensure => installed,
    notify => Service['postfix'],
  }
  service { 'postfix':
    name       => 'postfix',
    ensure     => running,
    hasrestart => true,
    enable     => true,
  }
}
