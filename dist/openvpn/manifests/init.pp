class openvpn {

  include openvpn::params

  $openvpn_dir = $openvpn::params::openvpn_dir
  $package     = $openvpn::params::package

  package { $package: ensure => installed; }

  service {
    "openvpn":
      enable  => true,
      ensure  => running,
      require => Package["$package"],
  }

  file { $openvpn_dir: ensure => directory; }

}
