class ipsec(
  $my_ip,
  $their_ip,
  $local_subnet,
  $remote_subnet,
  $local_router,
  $remote_router,
  $key ) {

  include ipsec::params

  package{ $ipsec::params::ipsec_packages:
    ensure => present,
    alias  => 'ipsec',
  }

  if $::operatingsystem == 'FreeBSD' {
    # We need to put that in to rc.conf somehow too.
    service{ 'ipsec':
      enable => true,
    }
  }

  class{ 'ipsec::setkey':
    my_ip         => $my_ip,
    their_ip      => $their_ip,
    local_subnet  => $local_subnet,
    remote_subnet => $remote_subnet,
  }

  class{ 'ipsec::racoon':
    my_ip         => $my_ip,
    their_ip      => $their_ip,
    local_subnet  => $local_subnet,
    remote_subnet => $remote_subnet,
    key           => $key,
  }

}
