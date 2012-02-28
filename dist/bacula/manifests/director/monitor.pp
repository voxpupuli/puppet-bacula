# Class: bacula::director::monitor
#
# This class installs and configures the Nagios hosts and services for monitoring bacula director
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class bacula::director::monitor {

  include nagios::params

  @@nagios_service { "check_baculadir_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 bacula-dir',
    service_description => "check_baculadir_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_baculasd_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 bacula-sd',
    service_description => "check_baculasd_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_baculadisk_${hostname}":
    # nagios is now monitoring all disks, so no need here
    ensure              => absent,
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_xvdc',
    service_description => "check_bacula_disk_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  $nagios_plugins_path = $::nagios::params::nagios_plugins_path
  # put here because it needs the database password from the 
  file { "${nagios_plugins_path}/check_bacula.pl":
    content => template("nagios/check_bacula.pl.erb"),
    group   => $::nagios::params::nrpe_group,
    mode    => 0750,
    ensure  => present,
  }

  nagios::nrpe::command {
    "check_bacula":
      path    => "${nagios_plugins_path}/check_bacula.pl",
      args    => '-H $ARG1$ -w 1 -c 1 -j $ARG2$',
      require => File["/usr/lib/nagios/plugins/check_bacula.pl"],
  }

}

