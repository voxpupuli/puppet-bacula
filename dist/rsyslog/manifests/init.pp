class rsyslog {

  if $::operatingsystem == 'debian' or $::operatingsystem == 'ubuntu' {

    service{ 'rsyslog':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

  }

}
