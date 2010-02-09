class apache::dev {
  # this also installs apr, and apr-util
  require apache
  # this is just the name for RH
  $apache_dev = 'httpd-devel'
  package{$apache_dev: ensure => installed}
}
