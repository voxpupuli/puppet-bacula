# Class: account::master
#
# This class installs and manages user accounts
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class account::master {
  File { mode => '0755', owner => 'puppet', group => 'puppet' }
  file {
    '/usr/local/bin/setpass.rb': source => 'puppet:///modules/account/setpass.rb';
    '/etc/puppet/userpw': recurse => true, mode => '0600';
  }
  package {'mkpasswd': ensure => installed, }
}
