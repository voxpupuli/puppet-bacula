class sudo::params {
  case $operatingsystem {
    'freebsd': {
      $visudo_cmd   = "/usr/local/sbin/visudo"
      $sudoers_file = "/usr/local/etc/sudoers"
      $sudoers_tmp  = "/usr/local/etc/sudoers.tmp"
    }
    'sles': {
      $visudo_cmd   = "/usr/sbin/visudo"
      $sudoers_file = "/etc/sudoers"
      $sudoers_tmp  = "/etc/sudoers.tmp"
      $visiblepw    = false # Because sles 11 sudo is dinosaurian
    }
    default: {
      $visudo_cmd   = "/usr/sbin/visudo"
      $sudoers_file = "/etc/sudoers"
      $sudoers_tmp  = "/etc/sudoers.tmp"
      $visiblepw    = true
    }
  }
}
