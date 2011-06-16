define openvpn::client (
    $server,
    $port = '1194',
    $proto = 'udp',
    $dev   = 'tun'

  ) {

  package { "openvpn": ensure => installed; }

}

