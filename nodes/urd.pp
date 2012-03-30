node urd {
  include role::server
  include service::bootserver
  include jumpstart

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

  Preseed {
    proxy => hiera("proxy")
  }

  preseed { "/var/www/${fqdn}/d-i/debian_base.cfg": }
  preseed { "/var/www/${fqdn}/d-i/debian_ops.cfg": }

}
