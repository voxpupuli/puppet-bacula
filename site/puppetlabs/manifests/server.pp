class puppetlabs::server {

  class { "collectd::params":
    site_alias      => "visage.puppetlabs.com",
    collectd_server => "baal.puppetlabs.com",
  }
}
