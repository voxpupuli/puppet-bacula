# Class: collectd::params
#
# This class contains the parameter for the collectd module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class collectd::params {

  $collectd_server = 'baal.puppetlabs.com'

  case $operatingsystem {
    'ubuntu': {
      $collectd_configuration = '/etc/collectd/collectd.conf'
      $collectd_packages = 'collectd'
}
    'centos': {
      $collectd_packages = [ 'collectd', 'collectd-apache', 'collectd-dns', 'collectd-email', 'collectd-mysql', 'collectd-ping', 'collectd-rrdtool', 'collectd-snmp', 'collectd-web', 'collectd-virt', 'collectd-ipmi' ]
      $collectd_configuration = '/etc/collectd.conf'
    }

  }
}
