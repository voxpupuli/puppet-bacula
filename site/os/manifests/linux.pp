class os::linux {

  include packages::admin
  include linuxlogo
  include virtual::packages
  include packages
  include vim
  include git

  case $operatingsystem {
    debian:  { include os::linux::debian }
    ubuntu:  { include os::linux::ubuntu }
    centos:  { include os::linux::centos }
    fedora:  { include os::linux::fedora }
    default: { notify { "Linux distro ${operatingsystem} hos no love": } }
  }

  File {
    owner => root,
    group => root,
    mode  => 644
  }

  file {
    "/etc/timezone":  owner => root, group => root, mode => 644, content => "America/Vancouver";
    "/etc/localtime": owner => root, group => root, mode => 644, source  => "/usr/share/zoneinfo/America/Vancouver";
  }

  cron {
    "clean /tmp":
      command => "/usr/bin/find /tmp -mtime +3 -print0 | xargs --no-run-if-empty -0 rm -r >/dev/null 2>&1",
      ensure  => present,
      user => root,  minute => 10,  hour => 20, weekday => 0;
  }

  file {
    "/usr/local/bin/weigh":
      mode   => 755,
      source => "puppet:///modules/puppetlabs/usr/local/bin/weigh",
  }

  if $is_virtual == 'true' {
    sysctl::value { "vm.swappiness": value => '25'; }
  }

}
