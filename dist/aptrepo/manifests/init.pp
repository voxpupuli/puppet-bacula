# Class: aptrepo
#
# This class installs and configures a local APT repo
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class aptrepo {
  include apache

  package { "dpkg-dev":
    ensure => present,
  }

  file { "/opt/repository/apt":
    ensure => directory,
  }

  file { [ "/opt/repository/apt/binary", "/opt/repository/apt/source" ]:
    ensure => directory,
    require => File["/opt/repository/apt"],
  }

  apache::vhost { "apt.puppetlabs.com": 
    port => "80",
    docroot => "/opt/repository/apt",
    webdir => "/opt/repository/apt",
  }
}

