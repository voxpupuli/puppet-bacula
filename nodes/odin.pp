node odin {
  include role::server

  # Customer Groups
  Account::User <| tag == customer |>
  Group <| tag == customer |>

  $ssh_customer = [
    "mcgraw", # (#12410)
    "suddenlink", # support:733
  ]

  ssh::allowgroup { "prosvc": }
  ssh::allowgroup { $ssh_customer: chroot => true; }
}
