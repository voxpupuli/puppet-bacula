class ipsec::params {

  case $operatingsystem {
    'freebsd': {
      $ipsec_setkey_conf = '/etc/ipsec.conf'
      $ipsec_racoon_conf = '/usr/local/etc/racoon/racoon.conf'
      $ipsec_psk_file    = '/usr/local/etc/racoon/psk.txt'
      $ipsec_setkey_cmd  = '/sbin/setkey'
      # $ipsec_packages = [ 'security/racoon2' ] # racoon2 is sketch
      $ipsec_packages = [ 'security/ipsec-tools' ]
      $ipsec_racoon_dir = '/usr/local/etc/racoon'
      $ipsec_racoon_daemon = 'racoon'
    }
    'debian': {
      $ipsec_setkey_conf = '/etc/setkey.conf'
      $ipsec_setkey_cmd  = '/sbin/setkey'
      $ipsec_packages = [ 'ipsec-tools' ]
    }
    default: {
      fail('sorry, cannot do IPSEC on here')
    }
  }

}
