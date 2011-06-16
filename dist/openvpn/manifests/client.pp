define openvpn::client (
    $server,
    $port = '1194',
    $proto = 'udp',
    $dev   = 'tun'

  ) {

  package { "openvpn": ensure => installed; }

  file { "/etc/openvpn/$server.conf":
    owner => root,
    group => root,
    mode  => 640,
    content => template("openvpn/client.conf.erb");
  }

  service { "openvpn": enable => true, ensure => running; }

}

