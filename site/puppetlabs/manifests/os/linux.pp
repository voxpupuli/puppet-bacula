class puppetlabs::os::linux {

  include packages::admin
  include linuxlogo
  include virtual::packages
  include packages

  file {
    "/etc/timezone":  owner => root, group => root, mode => 644, content => "America/Vancouver";
    "/etc/localtime": owner => root, group => root, mode => 644, source  => "/usr/share/zoneinfo/America/Vancouver";
  }

  cron {
    "clean /tmp":
      command => "/usr/bin/find /tmp -mtime +3 -print0 | xargs --no-run-if-empty -0 rm",
      ensure  => present,
      user => root,  minute => 10,  hour => 20, weekday => 0;
  }

}
