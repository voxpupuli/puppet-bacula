# Class: bacula::openldap
#
# This class creates a define that creates a cron job to backup OpenLDAP
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup OpenLDAP
#
# Requires:
#
# Sample Usage:
#
# bacula::openldap { 'puppetlabs-config':
#   suffix => 'cn=config',
# }
#
#
define bacula::openldap( $suffix ) {

  include bacula::params
  include bacula::openldap::resources

  cron { "bacula_openldap_${name}":
    command => "/usr/sbin/slapcat -b '${suffix}' -l /var/lib/bacula/openldap/${name}.ldif",
    user    => root,
    hour    => [0, 4, 8, 12, 16, 20],
    minute  => 15,
    require => File['/var/lib/bacula/openldap'],
  }

  bacula::job { "${::fqdn}-openldap-${name}":
    files => "/var/lib/bacula/openldap/${name}.ldif",
  }
}
