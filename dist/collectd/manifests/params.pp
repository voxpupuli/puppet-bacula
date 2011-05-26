# Class: collectd::params
#
# Paramaters for operatingsystems specific information regarding collectd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# include collectd::params
#
class collectd::params {

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

