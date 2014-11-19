# Class: bacula::params
#
# Set some platform specific paramaters.
#
class bacula::params {

  $file_retention = '45 days'
  $job_retention  = '6 months'
  $autoprune      = 'yes'
  $monitor        = true

  $db_type          = hiera('bacula::params::db_type', 'pgsql')
  $bacula_director  = hiera('bacula::params::bacula_director', undef)
  $bacula_storage   = hiera('bacula::params::bacula_storage', undef)
  $director_name    = hiera('bacula::params::director_name', $bacula_director)
  $director_address = hiera('bacula::params::director_address', $director_name)

  case $::is_pe {
    'false',false: {
      include puppet::params
      $ssl_dir = $puppet::params::puppet_ssldir
    }
    'true',true: {
      $ssl_dir = '/etc/puppetlabs/puppet/ssl'
    }
  }

  case $::operatingsystem {
    'ubuntu','debian': {
      $bacula_director_packages = [ 'bacula-director-common', "bacula-director-${db_type}", 'bacula-console' ]
      $bacula_director_services = [ 'bacula-director' ]
      $bacula_storage_packages  = [ 'bacula-sd', "bacula-sd-${db_type}" ]
      $bacula_storage_services  = [ 'bacula-sd' ]
      $bacula_client_packages   = 'bacula-client'
      $bacula_client_services   = 'bacula-fd'
      $conf_dir                 = '/etc/bacula'
      $bacula_dir               = '/etc/bacula/ssl'
      $client_config            = '/etc/bacula/bacula-fd.conf'
      $homedir                  = '/var/lib/bacula'
      $rundir                   = '/var/run/bacula'
      $bacula_user              = 'bacula'
      $bacula_group             = $bacula_user
    }
    'centos','fedora','sles': {
      $bacula_director_packages = [ 'bacula-director-common', "bacula-director-${db_type}", 'bacula-console' ]
      $bacula_director_services = [ 'bacula-dir' ]
      $bacula_storage_packages  = [ 'bacula-sd', "bacula-sd-${db_type}" ]
      $bacula_storage_services  = [ 'bacula-sd' ]
      $bacula_client_packages   = 'bacula-client'
      $bacula_client_services   = 'bacula-fd'
      $conf_dir                 = '/etc/bacula'
      $bacula_dir               = '/etc/bacula/ssl'
      $client_config            = '/etc/bacula/bacula-fd.conf'
      $homedir                  = '/var/lib/bacula'
      $rundir                   = '/var/run'
      $bacula_user              = 'bacula'
      $bacula_group             = $bacula_user
    }
    'freebsd': {
      $bacula_client_packages = 'sysutils/bacula-client'
      $bacula_client_services = 'bacula-fd'
      $conf_dir               = '/usr/local/etc/bacula'
      $bacula_dir             = '/usr/local/etc/bacula/ssl'
      $client_config          = '/usr/local/etc/bacula/bacula-fd.conf'
      $rundir                 = '/var/run'
      $homedir                = '/var/db/bacula'
      $bacula_user            = 'bacula'
      $bacula_group           = $bacula_user
    }
    default: { fail("bacula::params has no love for ${::operatingsystem}") }
  }

  $certfile = "${conf_dir}/ssl/${::clientcert}_cert.pem"
  $keyfile  = "${conf_dir}/ssl/${::clientcert}_key.pem"
  $cafile   = "${conf_dir}/ssl/ca.pem"
}
