class bacula::ssl {

  include bacula::params
  include puppet::params

  $ssl_dir           = $bacula::params::ssl_dir
  $bacula_parent_dir = $bacula::params::bacula_parent_dir
  $bacula_dir        = $bacula::params::bacula_dir

  File {
    owner => 'bacula',
    group => '0',
    mode  => '0640'
  }

  file { $bacula_parent_dir:
    ensure => 'directory'
  } ->

  file { $bacula_dir:
    ensure => 'directory'
  }

  file { "${bacula_dir}/${::clientcert}_cert.pem":
    ensure  => 'file',
    source  => "${ssl_dir}/certs/${::clientcert}.pem",
    require => File[$bacula_dir],
    notify  => Service[$bacula::params::bacula_client_services],
  }

  file { "${bacula_dir}/${::clientcert}_key.pem":
    ensure  => 'file',
    source  => "${ssl_dir}/private_keys/${::clientcert}.pem",
    require => File[$bacula_dir],
    notify  => Service[$bacula::params::bacula_client_services],
  }

  file { "${bacula_dir}/ca.pem":
    ensure  => 'file',
    source  => "${ssl_dir}/certs/ca.pem",
    require => File[$bacula_dir],
    notify  => Service[$bacula::params::bacula_client_services],
  }
}
