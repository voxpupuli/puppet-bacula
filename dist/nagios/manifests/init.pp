# Class: nagios
#
# This class installs and configures Nagios
#
# Parameters:
#   $nrpe_server:
#     IP address of the NRPE monitoring server
#
# Actions:
#
# Requires:
#   - The nagios::params class
#
# Sample Usage:
#
class nagios {
  include nagios::params

  $nrpe_server = $nagios::params::nrpe_server

  package { [ $nagios::params::nagios_plugin_packages, $nagios::params::nrpe_packages ]:
    ensure => installed,
  }

  file { '/etc/nagios': 
    ensure => present,
    require => Package[$nagios::params::nrpe_packages],
  }

  file { $nagios::params::nrpe_configuration:
    ensure => present,
    owner => nagios,
    group => nagios,
    content => template('nagios/nrpe.cfg.erb'),
    notify => Service[$nagios::params::nrpe_service],
    require => File['/etc/nagios'],
  }

  service { $nagios::params::nrpe_service:
    pattern => 'nrpe',
    ensure => running,
    enable     => true,
    hasrestart => true,
    require => [ File[$nagios::params::nrpe_configuration], Package[$nagios::params::nrpe_packages] ],
  }

  @@nagios_host { $fqdn:
    ensure => present,
    alias => $hostname,
    address => $ipaddress,
    use => 'generic-host',
    target => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_hostextinfo { $fqdn:
    ensure => present,
    icon_image_alt => $operatingsystem,
    icon_image => "base/$operatingsystem.png",
    statusmap_image => "base/$operatingsystem.gd2",
    target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ping_${hostname}":
    use => 'generic-service',
    check_command => 'check_ping!100.0,20%!500.0,60%',
    host_name => "$fqdn",
    service_description => "check_ping_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ssh_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_ssh', 
    service_description => "check_ssh_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_dns_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_dns',
    service_description => "check_dns_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_bacula_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_bacula',
    service_description => "check_bacula_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_disk_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_nrpe_1arg!check_xvda',
    service_description => "check_disk_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_load_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_nrpe_1arg!check_load',
    service_description => "check_load_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  file { "/usr/lib/nagios/plugins/check_bacula.pl":
    source => "puppet:///modules/nagios/check_bacula.pl",
    mode => 0755,
    ensure => present,
  }
}
