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
class bacula::director {
  require mysql::server
  require bacula

  package { $bacula::params::bacula_director_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_director_services:
    ensure => running,
    enable => true,
    hasrestart => true,
    require => Package[$bacula::params::bacula_director_packages],
  }

  file { 
    "/bacula": ensure => directory;
    "/etc/bacula/bacula-dir.conf": owner => root, group => bacula, mode => 640,
      content => template("bacula/bacula-dir.conf.erb");
  }

  bacula::mysql { 'bacula': }

  @@firewall {
    '0170-INPUT allow tcp 9102':
      proto  => 'tcp',
      dport  => '9102',
      source => "$ipaddress",
      jump   => 'ACCEPT',
  }

}
