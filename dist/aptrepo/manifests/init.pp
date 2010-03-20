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
  require apache

  package { "dpkg-dev":
    ensure => present,
  }

  file { "/opt/repository":
    ensure => directory,
  }

  file { [ "/opt/respository/binary", "/opt/repository/source" ]:
    ensure => directory,
    require => File["/opt/repository"],
  }

  apache::vhost { "apt-repository": 
    port => "80",
    docroot => "/opt/respository",
    webdir => "/opt/repository",
  }
}

