class sudo::params {
  case $operatingsystem {
    'freebsd': {
      $visudo_cmd   = "/usr/local/sbin/visudo"
      $sudoers_file = "/usr/local/etc/sudoers"
      $sudoers_tmp  = "/usr/local/etc/sudoers.tmp"
    }
    default: {
      $visudo_cmd   = "/usr/sbin/visudo"
      $sudoers_file = "/etc/sudoers"
      $sudoers_tmp  = "/etc/sudoers.tmp"
    }
  }
}
