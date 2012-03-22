class openvpn::server (
    $port   = '1194',
    $proto  = 'udp',
    $dev    = 'tun',
    $cert   = "server.crt",
    $key    = "server.key",
    $ca     = "ca.crt",
    $dh     = "dh2048.pem",
    $server = "10.8.0.0 255.255.255.0",
    $route  = '',
    $cipher = "AES-192-CBC",
    $dns    = '',
    $crl    = ''
  ) {
  include openvpn
  include openvpn::params

  $openvpn_dir = $openvpn::params::openvpn_dir

  # Server configuration file
  #file { "${openvpn_dir}/${name}.conf":
  file { "${openvpn_dir}/openvpn.conf":
    owner   => root,
    group   => 0,
    mode    => 0600,
    content => template("openvpn/server.conf.erb");
  }

  # Set permissions on the rest
  file { "${openvpn_dir}/ca.crt":      owner => root, group => 0, mode => 640; }
  file { "${openvpn_dir}/${name}.crt": owner => root, group => 0, mode => 640; }
  file { "${openvpn_dir}/${name}.key": owner => root, group => 0, mode => 600; }
  file { "${openvpn_dir}/dh2048.pem":  owner => root, group => 0, mode => 600; }
  file { "${openvpn_dir}/crl.pem":     owner => root, group => 0, mode => 644, content => template($crl); }
  file { "${openvpn_dir}/ccd":
    ensure => directory,
    owner  => root,
    group  => 0,
    mode   => 755;
  }

  exec { "create dh2048.pem":
    cwd     => "${openvpn_dir}",
    command => "/usr/bin/openssl dhparam -out dh2048.pem 2048",
    creates => "${openvpn_dir}/dh2048.pem",
    before  => Service["openvpn"],
  }


}

