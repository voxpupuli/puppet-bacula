class puppetlabs::pluto {

  ssh::allowgroup { "developers": }
  ssh::allowgroup { "prosvc": }

  # Customer Groups
  Account::User <| group == vmware |>
  Group <| title == vmware |>
  ssh::allowgroup { "vmware": chroot => true; }

  Account::User <| group == motorola |>
  Group <| title == motorola |>
  ssh::allowgroup { "motorola": chroot => true; }

  Account::User <| group == nokia |>
  Group <| title == nokia |>
  ssh::allowgroup { "nokia": chroot => true; }

  Account::User <| group == blackrock |>
  Group <| title == blackrock |>
  ssh::allowgroup { "blackrock": chroot => true; }

  Account::User <| group == secureworks |>
  Group <| title == secureworks |>
  ssh::allowgroup { "secureworks": chroot => true; }
  
  Account::User <| group == bioware |>
  Group <| title == bioware |>
  ssh::allowgroup { "bioware": chroot => true; }

  package { "cryptsetup": ensure => installed; }

  exec { "/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4":
    creates => '/var/chroot.key';
  }
  
  file { 
    "/var/chroot.key": mode => 0400, require => Exec["/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4"];
  }

  file {
    "/opt/enterprise": 
      owner => root,
      group => developers,
      mode => 775,
      recurse => true;
  }

}

