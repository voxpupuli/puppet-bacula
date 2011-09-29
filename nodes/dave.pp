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
}
