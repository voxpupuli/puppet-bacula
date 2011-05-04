

#  ha.cf
#       There are lots of options in this file.  All you have to have is a set
#       of nodes listed {"node ...} one of {serial, bcast, mcast, or ucast},
#       and a value for "auto_failback".


class heartbeat (
    use_logd = "no",
    keepalive = "2",
    deadtime = "10",
    warntime = "5",


    logfacility   = "local0",
    auto_failback = "off"

  ) {

  package {
    "heartbeat": ensure => installed;
  }

  service {
    "heartbeat":
      ensure    => running,
      enable    => true,
      hasstatus => true;
  }
  concat { "/etc/heartbeat/authkeys":
    mode    => '0600',
    require => Package["heartbeat"],
    notify  => Service["heartbeat"].
  }

  concat { "/etc/heartbeat/haresources":
    mode    => '0640',
    require => Package["heartbeat"],
    notify  => Service["heartbeat"].
  }

  file {
#    "/etc/heartbeat/authkeys":
#      owner   => root,
#      group   => root,
#      mode    => 600,
#      #source  => "puppet:///modules/heartbeat/authkeys",
#      content => template("heartbeat/authkeys"),
#      notify  => Service["heartbeat"];
#  "/etc/heartbeat/haresources":
#    owner  => root,
#    group  => root,
#    mode   => 640,
#    source => "puppet:///modules/heartbeat/haresources",
#    notify => Service["heartbeat"];
    "/etc/heartbeat/ha.cf":
      owner  => root,
      group  => root,
      mode   => 640,
      #source => ["puppet:///modules/heartbeat/ha.cf_${hostname}", "$files/etc/heartbeat/ha.cf"], notify => Service["heartbeat"];
  }

}

