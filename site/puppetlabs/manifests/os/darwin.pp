class puppetlabs::os::darwin {

  cron { "update macports":
    command => "/opt/local/bin/port -q selfupdate",
    minute  => 0,
    hour    => 0,
    weekday => 0,
  }

}
