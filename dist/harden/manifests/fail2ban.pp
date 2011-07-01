class fail2ban {

  package { "fail2ban": ensure => installed; }

  service { "fail2ban":
    enable    => true,
    ensure    => running,
    hasstatus => true,
  }

  concat::fragment {
    "fail2ban-jail-header":
      order   => 1,
      target  => '/etc/fail2ban/jail.local',
      content => "[DEFAULT]";
  }

  @@concat::fragment {
    "fail2ban-jail-host-$fqdn":
      order   => 2,
      target  => '/etc/fail2ban/jail.local',
      content => "ignoreip = $ipaddress",
      tag     => "fail2ban-ignoreip";
  }

  Concat::Fragment <<| tag == "fail2ban-ignoreip" |>>

  concat {
    '/etc/fail2ban/jail.local':
      owner  => root,
      group  => root,
      mode   => 644,
      notify => Service["fail2ban"];
  }

}

