# Class: freight
#
# This class installs and configures a local APT repo using freight
#
# Actions:
# - Install appropriate apache vhost for freight instance
# - Add rcrowley's repository key so freight can be apt-installed
# - Install, configure and setup freight instance
# - Installs gpg-agent for signing packages
#
# Requires:
# - The apache class and vhost definition
#
# Sample Usage:
#   freight::repo { 'freight':
#     freight_vhost_name  => 'freight.somewhere.com',
#     freight_docroot     => '/var/www/html',
#     freight_gpgkey      => 'me@somewhere.com',
#     freight_libdir      => '/var/lib/freight',
#   }
#
class freight {

  package { 'freight':
    ensure  => present,
    require => Apt::Source["rcrowley.list"],
  }

  #file { '/etc/freight.conf':
  #  ensure    => present,
  #  content   => template('freight/freight.conf.erb'),
  #  require   => Package['freight'],
  #}

  file { '/etc/freight.conf.d':
    ensure    => directory,
    purge     => true,
    recurse   => true,
    require   => Package['freight'],
  }

  apt::source { "rcrowley.list":
    uri           => "http://packages.rcrowley.org/",
    require       => Exec["rcrowley_key"],
  }

  exec { "import rcrowley apt key":
    user    => root,
    alias   => "rcrowley_key",
    command => "/usr/bin/wget -q -O - http://packages.rcrowley.org/pubkey.gpg | apt-key add -",
    unless  => "/usr/bin/apt-key list | grep -q 7DF49CEF",
    before  => Exec["apt-get update"];
  }

  gpg::agent { "root":
    options => [
      "--default-cache-ttl 999999999",
      "--max-cache-ttl     999999999",
      "--use-standard-socket",
    ],
  }

}

