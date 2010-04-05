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

  file { [ '/etc/nagios/conf.d/nagios_contactgroup.conf', '/etc/nagios/conf.d/nagios_contact.conf' ]:
    mode => '0644',
    before => Service[$nagios::params::nagios_service],
  }

  nagios_contractgroup { 'admins':
    alias => 'admins',
    members => 'jamtur01',
    ensure => present,
  }

  nagios_contact { 'jamtur01':
    alias => 'jamtur01',
    contact_name => 'jamtur01',
    email => 'james@puppetlabs.com',
    host_notification_commands => 'notify-host-by-email',
    service_notification_commands => 'notify-service-by-email',
    service_notification_period => '24x7',
    host_notification_period => '24x7',
    service_notification_options => 'w,u,c,r',
    host_notifications_options => 'd,r',
    ensure => present,
  }
}
