node odin {
  include role::server

  # Customer Groups
  Account::User <| tag == customer |>
  Group <| tag == customer |>

  $ssh_customer = [
    "vmware",
    "motorola",
    "nokia",
    "blackrock",
    "secureworks",
    "bioware",
    "wealthfront",
    "scea",        #10214
    "advance"
  ]

  ssh::allowgroup { "prosvc": }
  ssh::allowgroup { $ssh_customer: chroot => true; }
}
