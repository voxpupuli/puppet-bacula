class openvpn::params {

  case $operatingsystem {
    'freebsd': {
      $openvpn_dir = '/usr/local/etc/openvpn'
      $package     = 'security/openvpn'
    }
    default: {
      $openvpn_dir = '/etc/openvpn'
      $package     = 'openvpn'
    }
  }

}

