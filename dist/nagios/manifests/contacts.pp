# Class: nagios::contacts
#
# This class configures the Nagios contacts
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::contacts {

  include nagios::params

  file { [ '/etc/nagios3/conf.d/nagios_contactgroup.conf', '/etc/nagios3/conf.d/nagios_contact.conf' ]:
    mode => '0644',
    before => Service[$nagios::params::nagios_service],
  }

  Nagios_contact <| |>
  Nagios_contactgroup <| |>

}
