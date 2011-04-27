class puppetlabs::os::linux {

  include packages::admin
  include linuxlogo

  file {
    "/etc/timezone":  owner => root, group => root, mode => 644, content => "America/Vancouver";
    "/etc/localtime": owner => root, group => root, mode => 644, source  => "/usr/share/zoneinfo/America/Vancouver";
  }

  cron {
    "clean /tmp":
      command => "/usr/bin/find /tmp -mtime +3 -exec rm {} \;",
      user => root,  minute => 10,  hour => 20, weekday => 0;
  }

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    default: { }
  }

}
