class puppetlabs::os::linux {

  include packages::admin
  include linuxlogo

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

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    default: { }
  }

}
