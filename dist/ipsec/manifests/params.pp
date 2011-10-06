class ipsec::params {

  case $operatingsystem {
    'freebsd': {
      $ipsec_setkey_conf = '/usr/local/etc/racoon/setkey.conf'
      $ipsec_packages = [ 'security/ipsec-tools', 'security/racoon2' ]
    }
    'debian': {
      $ipsec_setkey_conf = '/etc/setkey.conf'
      $ipsec_packages = [ 'ipsec-tools' ]
    }
    default: {
      fail('sorry, cannot do IPSEC on here')
    }
  }

}
