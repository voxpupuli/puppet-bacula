# Class: puppet::params
#
# This class installs and configures parameters for Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::params {

  $puppet_storedconfig_password = 'password'

  case $operatingsystem {
     'centos', 'redhat', 'fedora', 'sles': {
       $puppetmaster_package='puppet-server'
       $puppemasterd_service='puppetmasterd'
       $puppetd_service='puppet'
       $puppetd_defaults='/etc/sysconfig/puppet'
       $puppet_dashboard_report=''
       $puppet_storedconfig_packages='mysql-devel'
       $puppet_conf='/etc/puppet/puppet.conf'
       $puppet_logdir='/var/log/puppet'
       $puppet_vardir='/var/lib/puppet'
       $puppet_ssldir='/var/lib/puppet/ssl'
       $puppet_path = '/usr/bin/puppet'
     }
     'ubuntu', 'debian': {
       $puppetmaster_package='puppetmaster'
       $puppemasterd_service='puppetmaster'
       $puppetd_service='puppet'
       $puppetd_defaults='/etc/default/puppet'
       $puppet_dashboard_report='/usr/lib/ruby/1.8/puppet/reports/puppet_dashboard.rb'
       $puppet_storedconfig_packages='libmysql-ruby'
       $puppet_conf='/etc/puppet/puppet.conf'
       $puppet_logdir='/var/log/puppet'
       $puppet_vardir='/var/lib/puppet'
       $puppet_ssldir='/var/lib/puppet/ssl'
       $puppet_path = '/usr/bin/puppet'
     }
     'freebsd': {
       $puppetd_service='puppet'
       $puppet_conf='/usr/local/etc/puppet/puppet.conf'
       $puppet_logdir='/var/log/puppet'
       $puppet_vardir='/var/puppet'
       $puppet_ssldir='/var/puppet/ssl'
       $puppet_path = '/usr/local/bin/puppet'
     }
     'darwin': {
       $puppetd_service='com.puppetlabs.puppet'
       $puppet_conf='/etc/puppet/puppet.conf'
       $puppet_logdir='/var/log/puppet'
       $puppet_vardir='/var/lib/puppet'
       $puppet_ssldir='/etc/puppet/ssl'
       $puppet_path = '/opt/local/bin/puppet'
     }
     'solaris': { # If anyone installs open source puppet they're on their own
       $puppetd_service='network/puppetagent'
       $puppet_conf='/etc/puppetlabs/puppet/puppet.conf'
       $puppet_logdir='/var/log/pe-puppet'
       $puppet_vardir='/var/opt/lib/puppet'
       $puppet_ssldir='/etc/puppetlabs/puppet/ssl'
       $puppet_path = '/usr/local/bin/puppet'
     }
     default: { fail("Module puppet::params has no definition for \"${operatingsystem}\"") }
  }

  # Behold, the list of platforms that have horrible package mangement!
  if $kernel == 'Darwin' or $kernel == 'SunOS' or $kernel == 'FreeBSD' or $operatingsystem == 'SLES' {
    $update_puppet = undef
  }
  else {
    $update_puppet = true
  }
}