node ran {
  include role::server
  include puppetlabs::service::bootserver

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

}
