node odin {
  include role::server

  # Customer Groups
  Account::User <| tag == customer |>
  Group <| tag == customer |>
  Ssh_authorized_key <| tag == customer |>

  $ssh_customer = [
    "thompsonreuters", # (#13003)
  ]


  ssh::allowgroup { "prosvc": }
  ssh::allowgroup { "support": }
  ssh::allowgroup { $ssh_customer: chroot => true }
  ssh::allowgroup { "developers": }

  ssh::allowgroup { 'motorola': chroot => true, tcpforwarding => true } # support:767
}
