# this code comes from windows refund
class logrotate{
  package { 'logrotate':
    ensure => installed,
  }
  File{
    owner => root,
    group => root,
    require => Package['logrotate'],
  }
  file { "/etc/logrotate.d":
    ensure  => directory,
    mode    => 755,
  }
  file {"/etc/logrotate.conf":
    source  => "puppet:///modules/logrotate/logrotate.conf",
    mode    => 0644,
  }
}

define logrotate::file( $log, $options, $postrotate = "NONE" ) {
  # $options should be an array containing 1 or more logrotate directives (e.g. missingok, compress)
  include logrotate
  file { "/etc/logrotate.d/${name}":
    owner => root,
    group => root,
    mode => 644,
    content => template("logrotate/logrotate.erb"),
    require => File["/etc/logrotate.d"],
  }
}
