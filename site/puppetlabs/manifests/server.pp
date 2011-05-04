class puppetlabs::server {

  class { "collectd::params":
    site_alias      => "visage.puppetlabs.lan",
    collectd_server => "baal.puppetlabs.lan",
  }
}
