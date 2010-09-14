# Class: puppetlabs_ssl::params
#
# This class manages parameters for the Puppet Labs SSL module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs_ssl::params {

  case $operatingsystem {
    'centos', 'fedora', 'redhat': {
       $ssl_path = '/etc/pki'
    }
    'ubuntu', 'debian': {
       $ssl_path = '/etc/ssl/'
    }
    Default: { $ssl_path = '/etc/ssl/' }
  }

}
