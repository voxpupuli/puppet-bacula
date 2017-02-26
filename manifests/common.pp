# This class configures and installs the bacula client packages and enables the
# service, so that bacula jobs can be run on the client including this
# manifest.
#
class bacula::common {

  include ::bacula
  include ::bacula::client

  $conf_dir        = $::bacula::conf_dir
  $bacula_user     = $::bacula::bacula_user
  $bacula_group    = $::bacula::bacula_group
  $homedir         = $::bacula::homedir
  $homedir_mode    = $::bacula::homedir_mode
  $client_package  = $::bacula::client::packages

  File {
    ensure  => directory,
    owner   => $bacula_user,
    group   => $bacula_group,
    require => Package[$client_package],
  }

  file { $homedir:
    mode => $homedir_mode,
  }

  file { $conf_dir:
    ensure => 'directory',
    owner  => $bacula_user,
    group  => $bacula_group,
    mode   => '0750',
  }

}
