class ipsec( $from, $to, $ourside, $theirside , $key=undef ) {

  include ipsec::params

  package{ $ipsec::params::ipsec_packages:
    ensure => present,
    alias  => 'ipsec',
  }

  exec{ 'ipsec_make_tun_interfaces':
    command => "ifconfig gif0 create; ifconfig gif0 tunnel $from $to ; ifconfig gif0 inet 172.16.1.1 172.16.1.2 netmask 255.255.255.248",
    path => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
  }
  

  class{ 'ipsec::setkey':
    from      => $from,
    to        => $to,
    ourside   => $ourside,
    theirside => $theirside,
  }

  class{ 'ipsec::racoon':
    from      => $from,
    to        => $to,
    ourside   => $ourside,
    theirside => $theirside,
    key       => $key,
  }

}
