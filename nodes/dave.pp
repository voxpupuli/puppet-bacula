# This is our wonderfully named DC1 firewall.
# It runs FreeBSD so we don't want it including too much for now, or
# trying to do anything too smart.

node 'dave.dc1.puppetlabs.net' {
  include role::base

  # Accounts
  # This should probably be more selective on certain hosts/distros/oses
  include virtual::users
  Account::User <| groups == 'sysadmin' |>
  Group         <| tag == 'allstaff' |>

  include ntp

  include sudo
  sudo::allowgroup { 'sysadmin': }

  class{ 'ipsec':
    my_ip         => $::ipaddress,
    their_ip      => '74.85.255.4',
    local_subnet  => '10.0.42.0/24',
    remote_subnet => '192.168.100.0/24',
    local_router  => '10.0.42.1',
    remote_router => '192.168.100.1',
    key           => 'SacyimejhabNedinyootLeOtnemgionobfudolcodNaulufcaupAgDeumsisyicUthCopDur'
  }
}
