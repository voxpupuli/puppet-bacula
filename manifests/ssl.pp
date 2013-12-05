class bacula::ssl {

  include bacula::params

  file { '/etc/bacula/ssl':
    ensure => 'directory',
    mode   => '0640',
    owner  => 'bacula',
    group  => 'root',
  }

  file { "/etc/bacula/ssl/${::fqdn}_cert.pem":
    ensure  => 'file',
    source  => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    owner   => 'bacula',
    group   => 'root',
    mode    => '0640',
    require => File['/etc/bacula/ssl/'],
  }

  file { "/etc/bacula/ssl/${::fqdn}_key.pem":
    ensure  => 'file',
    source  => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    owner   => 'bacula',
    group   => 'root',
    mode    => '0640',
    require => File['/etc/bacula/ssl/'],
  }

  file { '/etc/bacula/ssl/ca.pem':
    ensure  => 'file',
    source  => '/var/lib/puppet/ssl/certs/ca.pem',
    owner   => 'bacula',
    group   => 'root',
    mode    => '0640',
    require => File['/etc/bacula/ssl/'],
  }
}
