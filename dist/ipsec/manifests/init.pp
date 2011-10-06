class ipsec {

  case $operatingsystem {
    'freebsd': {
      $ipsec_packages = [ 'security/ipsec-tools', 'security/racoon2' ]
    }
    'debian': {
      $ipsec_packages = [ 'ipsec-tools' ]
    }
    default: {
      fail('sorry, cannot do IPSEC on here')
    }
  }

  package{ $ipsec_packages:
    ensure => present,
    alias  => 'ipsec',
  }

}
