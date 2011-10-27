# CSC: Client specific configuration
define openvpn::server::csc (
  $content
  ) {

  include openvpn::params

  file {
    "${::openvpn::params::openvpn_dir}/ccd/${name}":
      owner   => root,
      group   => 0,
      mode    => 0644,
      content => $content,
  }

}

