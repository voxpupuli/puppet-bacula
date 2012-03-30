node urd {
  include role::server
  include service::bootserver
  include jumpstart

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

  preseed { "/var/www/${fqdn}/d-i/debian_base.cfg": }

}
