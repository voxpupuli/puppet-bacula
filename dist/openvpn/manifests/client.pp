define openvpn::client (
    $server,
    $port = '1194',
    $proto = 'udp',
    $dev   = 'tun',
    $cert  = $name
  ) {

  include openvpn

  file { "/etc/openvpn/$server.conf":
    owner   => root,
    group   => root,
    mode    => 640,
    content => template("openvpn/client.conf.erb");
  }

}

