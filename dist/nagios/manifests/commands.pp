# Class: nagios::commands
#
# This class configures the Nagios commands
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::commands {

  file { '/etc/nagios/conf.d/nagios_commands.cfg':
    mode => 0644,
    before => Service[$nagios::params::nagios_service],
  }

  nagios_command { "check_bacula":
    command_line => "/usr/lib/nagios/plugins/check_bacula.pl -H 24 -w 1 -c 1 -j '\$HOSTALIAS\$'",
    command_name => "check_bacula",
    ensure => present,
    target => "/etc/nagios/conf.d/nagios_commands.cfg",
    notify => Service[$nagios::params::nagios_service],
  }
}

