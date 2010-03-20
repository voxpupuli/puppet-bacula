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

  file { "/opt/repository":
    ensure => directory,
  }

  file { [ "/opt/repository/binary", "/opt/repository/source" ]:
    ensure => directory,
    require => File["/opt/repository"],
  }

  apache::vhost { "repository.reductivelabs.com": 
    port => "80",
    docroot => "/opt/repository",
    webdir => "/opt/repository",
  }
}

