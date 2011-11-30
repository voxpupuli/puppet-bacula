# this code comes from windows refund
class logrotate {

  File{
    owner   => root,
    group   => root,
    require => Package['logrotate'],
  }

  package { 'logrotate':
    ensure => installed,
  }

  file { "/etc/logrotate.d":
    ensure => directory,
    mode   => 755,
  }

  file { "/etc/logrotate.conf":
    source => "puppet:///modules/logrotate/logrotate.conf",
    mode   => 0644,
  }

}

