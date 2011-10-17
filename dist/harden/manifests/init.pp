class harden {

  include harden::fail2ban

  class {
    "denyhosts":
      adminemail => "root@puppetlabs.com",
      allow      => hiera("allowhosts"),
  }

}
