class ipsec::racoon(  $my_ip, $their_ip, $local_subnet, $remote_subnet , $key ) {

  include ipsec

  file{ $ipsec::params::ipsec_racoon_dir:
    ensure  => directory,
    owner   => 'root',
    mode    => '0700',
  } ->

  file{ $ipsec::params::ipsec_psk_file:
    ensure  => present,
    owner   => 'root',
    mode    => '0600',
    content => "${their_ip} ${key}\n",
  } ->

  file{ $ipsec::params::ipsec_racoon_conf:
    ensure  => present,
    owner   => 'root',
    mode    => '0600',
    content => template( 'ipsec/racoon.conf.erb'),
  } ~>

  service{ $ipsec::params::ipsec_racoon_daemon:
    ensure => true,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}
