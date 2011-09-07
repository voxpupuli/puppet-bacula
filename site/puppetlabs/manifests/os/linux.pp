class puppetlabs::os::linux {

  include packages::admin
  include linuxlogo
  include virtual::packages
  include packages

  file {
    "/etc/timezone":  owner => root, group => root, mode => 644, content => "America/Vancouver";
    "/etc/localtime": owner => root, group => root, mode => 644, source  => "/usr/share/zoneinfo/America/Vancouver";
  }

  tidy{ '/tmp/':
    age     => '3d',
    recurse => true,
    rmdirs  => true,
    type    => mtime,
  }

}
