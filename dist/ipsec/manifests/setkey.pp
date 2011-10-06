# NOTE: currently only works for a single VPN

class ipsec::setkey( $from, $to, $ourside, $theirside , $key ) {

  include ipsec::params

  file{ $ipsec::params::ipsec_setkey_conf:
    ensure  => present,
    owner   => root,
    mode    => '0600',
    content => template( 'ipsec/setkey.conf.erb'),
  }

  exec{ "$ipsec::params::ipsec_setkey_cmd -f $ipsec::params::ipsec_setkey_conf":
    refreshonly => true,
    notify      => File[ $ipsec::params::ipsec_setkey_conf ],
  }

}
