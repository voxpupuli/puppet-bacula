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
class bacula::director::monitor($db_user, $db_pw) {

  include icinga::params
  require ::monitoring

  @@nagios_service { "check_baculadir_${::fqdn}":
    use                      => 'generic-service',
    host_name                => $::fqdn,
    check_command            => 'check_nrpe!check_proc!1:1 bacula-dir',
    service_description      => "check_baculadir_${::fqdn}",
    first_notification_delay => '120',
    target                   => "${icinga::params::confd}/service/check_baculadir_${::fqdn}.cfg",
    tag                      => [$monitoring::export_tag],
  }

  @@nagios_servicedependency {"check_baculadir_${::fqdn}":
    ensure                        => present,
    host_name                     => $::fqdn,
    service_description           => "check_ping_${::fqdn}",
    dependent_host_name           => $::fqdn,
    dependent_service_description => "check_baculadir_${::fqdn}",
    execution_failure_criteria    => 'n',
    notification_failure_criteria => 'w,u,c',
    target                        => "${icinga::params::confd}/servicedependency/check_baculadir_${::fqdn}.cfg",
    tag                           => [$monitoring::export_tag],
  }

  @@nagios_service { "check_baculasd_${::fqdn}":
    use                      => 'generic-service',
    host_name                => $::fqdn,
    check_command            => 'check_nrpe!check_proc!1:1 bacula-sd',
    service_description      => "check_baculasd_${::fqdn}",
    target                   => "${icinga::params::confd}/service/check_baculasd_${::fqdn}.cfg",
    tag                      => [$monitoring::export_tag],
  }

  @@nagios_servicedependency {"check_baculasd_${::fqdn}":
    ensure                        => present,
    host_name                     => $::fqdn,
    service_description           => "check_ping_${::fqdn}",
    dependent_host_name           => $::fqdn,
    dependent_service_description => "check_baculasd_${::fqdn}",
    execution_failure_criteria    => 'n',
    notification_failure_criteria => 'w,u,c',
    target                        => "${icinga::params::confd}/servicedependency/check_baculasd_${::fqdn}.cfg",
    tag                           => [$monitoring::export_tag],
  }

  @@nagios_service { "check_baculadisk_${::fqdn}":
    # nagios is now monitoring all disks, so no need here
    ensure                   => absent,
    use                      => 'generic-service',
    host_name                => $::fqdn,
    check_command            => 'check_nrpe_1arg!check_xvdc',
    service_description      => "check_bacula_disk_${::fqdn}",
    target                   => "${icinga::params::confd}/service/check_baculadisk_${::fqdn}.cfg",
    tag                      => [$monitoring::export_tag],
  }

  @@nagios_servicedependency {"check_baculadisk_${::fqdn}":
    ensure                        => absent,
    host_name                     => $::fqdn,
    service_description           => "check_ping_${::fqdn}",
    dependent_host_name           => $::fqdn,
    dependent_service_description => "check_bacula_disk_${::fqdn}",
    execution_failure_criteria    => 'n',
    notification_failure_criteria => 'w,u,c',
    target                   => "${icinga::params::confd}/servicedependency/check_baculadisk_${::fqdn}.cfg",
    tag                      => [$monitoring::export_tag],
  }

  $nagios_plugins_path = $::icinga::params::nagios_plugins_path
  # put here because it needs the database password from the
  file { "${nagios_plugins_path}/check_bacula.pl":
    ensure  => present,
    content => template('icinga/check_bacula.pl.erb'),
    group   => $::icinga::params::nrpe_group,
    mode    => '0750',
  }

  icinga::nrpe_command { 'check_bacula':
    path    => "${nagios_plugins_path}/check_bacula.pl",
    args    => '-H $ARG1$ -w $ARG2$ -c $ARG3$ -j $ARG4$',
    require => File['/usr/lib/nagios/plugins/check_bacula.pl'],
  }

}
