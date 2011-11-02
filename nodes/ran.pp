node ran {
  include role::server
  include puppetlabs::service::bootserver
}
