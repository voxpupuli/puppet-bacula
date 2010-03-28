# Class: puppetdemo
#
# This class installs and configures the Puppet Labs demo site
#
# Parameters:
#
# Actions:
#   - Install Puppet
#
# Requires:
#
# Sample Usage:
#
class puppetdemo {
  include ruby
  include puppetdemo::params
  require puppet

  file { '/etc/puppetdemo':
    ensure => directory,
  }

  file { '/etc/puppetdemo/puppet.conf':
    ensure => present,
    content => template('puppetdemo/puppet.conf.erb'),
    require => File['/etc/puppetdemo'],
  }

}
