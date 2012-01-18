# some of this code comes from windows refund
class logrotate {

  if $kernel == "Linux" {

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

    file { "/etc/cron.daily/logrotate":
      owner   => root,
      group   => root,
      mode    => 755,
      content => template("logrotate/logrotate.cron")
    }

  } else {
    notify ("Class[logrotate] does not support kernel $kernel")
  }

}

