class ipsec::racoon(  $from, $to, $ourside, $theirside , $key ) {

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
    content => "$to $key\n",
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
