# Class: bacula::director
#
# This class installs and configures the Bacula Backup Director
#
# Parameters:
#
#
# Actions:
#  - Installs the bacula-director packages
#  - Installs the bacula storage daemon packages
#  - Starts the Bacula services
#  - Creates the /bacula mount point 
#
# Requires:
#
# Sample Usage:
#
class bacula::director (
    $port = 9101
  ) {
  require mysql::server
  require bacula

  package { $bacula::params::bacula_director_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_director_services:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package[$bacula::params::bacula_director_packages],
  }

  file { 
    "/bacula": 
      ensure  => directory;
#    "/etc/bacula/bacula-dir.conf": 
#      owner   => root, 
#      group   => bacula, 
#      mode    => 640,
#      content => template("bacula/bacula-dir.conf.erb");
  }

  @@concat::fragment {
    "bacula-director-header":
      order   => '00',
      target  => '/etc/bacula/bacula-dir.conf',
      content => template("bacula/bacula-dir-header.erb")
  }

  Concat::Fragment <<| target == '/etc/bacula/bacula-dir.conf' |>>

  concat {
    '/etc/bacula/bacula-dir.conf':
      owner => root,
      group => bacula,
      mode  => 640,
  }

  bacula::mysql { 'bacula': }

}
