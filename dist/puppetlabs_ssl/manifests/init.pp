# Class: puppetlabs_ssl
#
# This class installs the Puppet Labs SSL certificates
#
# Parameters:
#
# Actions:
# - Installs the Puppet Labs certificates
#
# Requires:
#
# Sample Usage:
#
class puppetlabs_ssl {

  include puppetlabs_ssl::params

  file { [ "$ssl_path/pl.cert", "$ssl_path/root.cert", "$ssl_path/pl.key" ]:
    source => 'puppet:///modules/site-files/ssl/$name',
    owner => 'root',
    group => 'root',
  }

}
