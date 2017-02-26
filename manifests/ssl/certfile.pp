# == Define: bacula::ssl::certfile
#
# Type to help the director install new client certificates.
#
define bacula::ssl::certfile {
  file { "certfile-${name}":
    path    => "${bacula::conf_dir}/ssl/${name}_cert.pem",
    owner   => $bacula::bacula_user,
    group   => '0',
    mode    => '0640',
    content => hiera("bacula_ssl_certfile_${name}"),
  }
}
