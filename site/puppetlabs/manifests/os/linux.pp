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
      command => "/usr/bin/find /tmp -mtime +3 | xargs rm",
      ensure  => absent,
  }

  tidy{ '/tmp/':
    age     => '3d',
    recurse => true,
    rmdirs  => true,
    type    => mtime,
  }

}

