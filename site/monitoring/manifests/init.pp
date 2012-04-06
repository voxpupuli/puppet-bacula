class monitoring {

  Nagios_host {
    ensure => present,
    use    => 'generic-host',
    target => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  nagios_host { "imana.puppetlabs.lan":       alias => "imana",  address => "192.168.100.1",   hostgroups => "office", }
  nagios_host { "tiki.puppetlabs.lan":        alias => "tiki",   address => "192.168.100.22",  hostgroups => "office", }
  nagios_host { "soko.puppetlabs.lan":        alias => "soko",   address => "192.168.100.23",  hostgroups => "office", }
  nagios_host { "juok.puppetlabs.lan":        alias => "juok",   address => "192.168.100.132", hostgroups => "office", }
  nagios_host { "kaang.puppetlabs.lan":       alias => "kaang",  address => "192.168.100.134", hostgroups => "office", }

  nagios_host { "vsphere.dc1.puppetlabs.net": alias => "vsphere", address => "10.0.1.30",     hostgroups => "dc1", }
  nagios_host { "vali.dc1.puppetlabs.net":    alias => "vali",    address => "10.0.42.31",    hostgroups => "dc1", }
  nagios_host { "balder.dc1.puppetlabs.net":  alias => "balder",  address => "10.0.42.32",    hostgroups => "dc1", }
  nagios_host { "eir.dc1.puppetlabs.net":     alias => "eir",     address => "10.0.42.33",    hostgroups => "dc1", }
  nagios_host { "rind.dc1.puppetlabs.net":    alias => "rind",    address => "10.0.42.34",    hostgroups => "dc1", }

  Nagios_service {
    use           => 'generic-service',
    target        => '/etc/nagios3/conf.d/nagios_service.cfg',
    check_command => 'check_ping!100.0,20%!500.0,60%',
    notify        => Service[$nagios::params::nagios_service],
  }

  nagios_service { "check_ping_imana":   host_name => "imana.puppetlabs.lan",       service_description => "check_ping_imana.puppetlabs.lan", } 
  nagios_service { "check_ping_tiki":    host_name => "tiki.puppetlabs.lan",        service_description => "check_ping_tiki.puppetlabs.lan", } 
  nagios_service { "check_ping_soko":    host_name => "soko.puppetlabs.lan",        service_description => "check_ping_soko.puppetlabs.lan", } 
  nagios_service { "check_ping_juok":    host_name => "juok.puppetlabs.lan",        service_description => "check_ping_juok.puppetlabs.lan", } 
  nagios_service { "check_ping_kaang":   host_name => "kaang.puppetlabs.lan",       service_description => "check_ping_kaang.puppetlabs.lan", } 

  nagios_service { "check_ping_vsphere": host_name => "vsphere.dc1.puppetlabs.net", service_description => "check_ping_vsphere.dc1.puppetlabs.net", } 
  nagios_service { "check_ping_vali":    host_name => "vali.dc1.puppetlabs.net",    service_description => "check_ping_vali.dc1.puppetlabs.net", } 
  nagios_service { "check_ping_balder":  host_name => "balder.dc1.puppetlabs.net",  service_description => "check_ping_balder.dc1.puppetlabs.net", } 
  nagios_service { "check_ping_eir":     host_name => "eir.dc1.puppetlabs.net",     service_description => "check_ping_eir.dc1.puppetlabs.net", } 
  nagios_service { "check_ping_rind":    host_name => "rind.dc1.puppetlabs.net",    service_description => "check_ping_rind.dc1.puppetlabs.net", } 

}
