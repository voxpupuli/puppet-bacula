# NOTE: currently only works for a single VPN

class ipsec::setkey( $from, $to, $ourside, $theirside , $key=undef ) {

  include ipsec

  file{ $ipsec::params::ipsec_setkey_conf:
    ensure  => present,
    owner   => root,
    mode    => '0600',
    content => template( 'ipsec/setkey.conf.erb'),
    notify      => Exec[ 'ipsec_do_setkey'],
  }

  exec{ 'ipsec_do_setkey':
    command => "${ipsec::params::ipsec_setkey_cmd} -f ${ipsec::params::ipsec_setkey_conf}",
    path        => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
    refreshonly => true,
  }

}
