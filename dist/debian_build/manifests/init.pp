# Class: debian_build
#
# This class installs and configures a Debian build environment for packages
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class debian_build {

  package { [ 'lintian', 'fakeroot', 'cdbs', 'devscripts', 'ruby-pkg-tools', 'dpkg-dev', 'debhelper', 'dh-make' ]:
    ensure => present,
  }

  user { 'debianbuild':
    ensure => present,
    managehome => true,
    home => '/home/debianbuild',
    require => File['/home/debianbuild'],
  }

  file { '/home/debianbuild':
    ensure => directory,
  }

  file { '/home/debianbuild/packages':
    ensure => directory,
    require => File['/home/debianbuild'],
  }

}
