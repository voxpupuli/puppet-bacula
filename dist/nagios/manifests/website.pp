# Class: nagios::website
#
# This class installs and configures checks of Websites
#
# Parameters:
#   $auth:
#       variable used to specify whether the check is with or without auth - should contain user:password
#
# Actions:
#   Installs either a check_http_site or check_http_site_auth Nagios service
#
# Requires:
#
# Sample Usage:
#
#   nagios::website { "f.q.d.n": }
#   nagios::website { "f.q.d.n": auth => 'user:password' }
#
define nagios::website(
  $auth = undef
  ) {

  include nagios::params

  if $auth {
    @@nagios_service { "$name":
      use                 => 'generic-service',
      check_command       => "check_http_site_auth!$name!$auth",
      host_name           => "$fqdn",
      service_description => "$name",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      require             => Nagios_command['check_http_site'],
      notify              => Service[$nagios::params::nagios_service],
    }
  }
  else {
    @@nagios_service { "$name":
      use                 => 'generic-service',
      check_command       => "check_http_site!$name",
      host_name           => "$fqdn",
      service_description => "$name",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      require             => Nagios_command['check_http_site_auth'],
      notify              => Service[$nagios::params::nagios_service],
    }
  }
}

