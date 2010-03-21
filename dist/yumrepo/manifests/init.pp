# Class: yumrepo
#
# This class installs and configures a local Yum repo
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class yumrepo {
  include apache

  file { "/opt/repository/yum":
    ensure => directory,
  }

  file { [ "/opt/repository/yum/base", "/opt/repository/yum/updates" ]:
    ensure => directory,
    require => File["/opt/repository/apt"],
  }

  apache::vhost { "yum.reductivelabs.com": 
    port => "80",
    docroot => "/opt/repository/yum",
    webdir => "/opt/repository/yum",
  }
}

