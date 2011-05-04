# Class: collectd::params
#
# This class contains the parameter for the collectd module
#
# Parameters:
#  collectd_server: the server to send collectd information to
#  site_alias: The hostname to provide the collectd visage
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# class { "collectd::params":
#   collectd_server => "collectd.example.com",
#   site_alias      => "visage.example.com",
# }
class collectd::params(collectd_server, site_alias) {

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
