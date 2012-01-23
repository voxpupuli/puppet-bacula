# Class: nagios
#
# This class installs and configures Nagios
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The nagios::params class
#
# Sample Usage:
#
class nagios (
    $nrpe_server
  ) {

  include nagios::params
  include nagios::nrpe

  # Install our own plugins everywhere from
  # dist/nagios/files/artisan-plugins/
  include nagios::plugins

  $nrpe_host_address = hiera("nrpe_host_address")

  package { $::nagios::params::nagios_plugin_packages:
    ensure   => installed,
    provider => $kernel ? {
      Darwin  => macports,
      default => undef,
    }
  }

  @@nagios_host { $fqdn:
    ensure     => present,
    alias      => $hostname,
    address    => $nrpe_host_address,
    hostgroups => $location,
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify     => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ping_${hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ping!150.0,20%!500.0,60%',
    host_name           => "$fqdn",
    service_description => "check_ping_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ssh_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_ssh',
    service_description => "check_ssh_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_dns_${hostname}":
    ensure              => absent,
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_dns',
    service_description => "check_dns_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_disk_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_alldisks',
    service_description => "check_alldisks_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_load_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_load',
    service_description => "check_load_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_zombie_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_zombie_procs',
    service_description => "check_zombie_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_munin-node_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 munin-node',
    service_description => "check_munin-node_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_env_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_env',
    service_description => "check_env_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @firewall {
    '0120-INPUT ACCEPT 5666':
      jump   => 'ACCEPT',
      dport  => '5666',
      proto  => 'tcp',
      source => "$nrpe_server"
  }

}
