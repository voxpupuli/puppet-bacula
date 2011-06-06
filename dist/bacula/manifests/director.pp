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
    $db_user = 'bacula',
    $db_pw   = 'ch@ng3me',
    $port    = 9101
  ) {
#  require mysql::server
#  require bacula

  package { $bacula::params::bacula_director_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_director_services:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package[$bacula::params::bacula_director_packages],
  }

  file { "/bacula": ensure  => directory; }

  concat::fragment {
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

  # backup the bacula database
  bacula::mysql { 'bacula': }

  # export firewall rules for client realization
  @@firewall {
    '0170-INPUT allow tcp 9102':
      proto  => 'tcp',
      dport  => '9102',
      source => "$ipaddress",
      jump   => 'ACCEPT',
  }

  mysql::db { "bacula":
    db_user => $db_user,
    db_pw   => $db_pw,
  }

  # put here because it needs the database password from the 
  file { "/usr/lib/nagios/plugins/check_bacula.pl":
    #source  => "puppet:///modules/nagios/check_bacula.pl",
    content => template("nagios/check_bacula.pl.erb"),
    mode    => 0755,
    ensure  => present,
  }


}

