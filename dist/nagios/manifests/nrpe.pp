class nagios::nrpe {

  include nagios::params

  $nrpe_pid            = $::nagios::params::nrpe_pid
  $nrpe_user           = $::nagios::params::nrpe_user
  $nrpe_group          = $::nagios::params::nrpe_group
  $nagios_plugins_path = $::nagios::params::nagios_plugins_path
  $nrpe_server         = $::nagios::nrpe_server

  file { $::nagios::params::nrpe_configuration:
    ensure  => present,
    owner   => $nagios::params::nrpe_user,
    group   => $nagios::params::nrpe_group,
    content => template('nagios/nrpe.cfg.erb'),
    notify  => Service[$nagios::params::nrpe_service],
    require => File['/etc/nagios'],
  }

  package { $::nagios::params::nrpe_packages:
    ensure   => installed,
    provider => $kernel ? {
      Darwin  => macports,
      default => undef,
    }
  }

  # this file path should be a variable
  file { $::nagios::params::nrpe_config_dir:
    ensure => directory,
    owner  => $nagios::params::nrpe_user,
    group  => $nagios::params::nrpe_group,
    mode   => '0750',
  }

}
