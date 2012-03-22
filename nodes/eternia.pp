node 'eternia.dc1.puppetlabs.net' {
  include role::server
  include grayskull

  package{'postgres': ensure => installed }

}
