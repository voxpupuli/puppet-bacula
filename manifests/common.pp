# = Class: bacula::common
#
# == Description
#
# This class configures and installs the bacula client packages and enables
# the service, so that bacula jobs can be run on the client including this
# manifest.
#
class bacula::common (
  $homedir  = $bacula::params::homedir,
  $packages = $bacula::params::bacula_client_packages,
  $user     = $bacula::params::bacula_user,
  $group    = $bacula::params::bacula_group,
) inherits bacula::params {

  include bacula::ssl
  include bacula::client

  file { $homedir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0700',
    require => Package[$packages],
  }
}
