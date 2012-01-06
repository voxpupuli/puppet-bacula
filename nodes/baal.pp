# Class: puppetlabs::baal
#
# This class installs and configures Baal
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
node baal {
  include role::server

  ssh::allowgroup { "techops": }
  ssh::allowgroup { "interns": }

  ###
  # Mysql
  #
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'
  include mysql::server

  ###
  # Base
  #
  include puppetlabs_ssl
  #include account::master
  include vim

  ###
  # Bacula
  #
  class { "bacula":
    director => hiera('bacula_director'),
    password => hiera('bacula_password'),
  }

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'qhF4M6TADEkl',
  }

  bacula::director::pool {
    "PuppetLabsPool-Full":
      #volret      => "1 months",
      volret      => "30 days",
      maxvolbytes => '2000000000',
      maxvoljobs  => '2',
      maxvols     => "20",
      label       => "Full-";
    "PuppetLabsPool-Inc":
      volret      => "14 days",
      maxvolbytes => '4000000000',
      maxvoljobs  => '50',
      maxvols     => "10",
      label       => "Inc-";
  }

  bacula::fileset {
    "Common":
      files => ["/etc"],
  }

  bacula::job {
    "${fqdn}":
      files    => ["/var/lib/bacula/mysql"],
  }

  ###
  # Monitoring
  #
  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  apt::pin{ 'wheey_repo_pin':
    release  => 'testing',
    priority => '200',
    filename => 'testingforgearman',
    wildcard => true
  }

  class {
    "nagios::gearman":
      server        => true,
      key           => hiera("gearman_key"),
      nagios_server => hiera("nagios_server")
  }

  class { 'nagios::server':
    site_alias        => "nagios.puppetlabs.com",
    external_commands => true,
    external_users    => '*',
    brokers           => [ '/usr/lib/mod_gearman/mod_gearman.o config=/etc/nagios3/gearman.conf'],
  }
  include nagios::webservices
  include nagios::dbservices
  include nagios::pagerduty

  file {
    "/etc/nagios3/htpasswd.users":
      owner => root,
      group => www-data,
      mode  => 0640,
      source => "puppet:///modules/puppetlabs/ops_htpasswd";
  }

  nagios::website { 'nagios.puppetlabs.com':    auth => 'monit:5kUg8uha', }
  nagios::website { 'dashboard.puppetlabs.com': auth => 'monit:5kUg8uha', }
  nagios::website { 'munin.puppetlabs.com':     auth => 'monit:5kUg8uha', }
  nagios::website { 'docs.puppetlabs.com': } # monitored here to avoid resource collision

  class { "munin::server": site_alias => "munin.puppetlabs.com"; }
  include munin::dbservices

  apache::vhost { $fqdn:
    options  => "None",
    priority => '08',
    port     => '80',
    docroot  => '/var/www',
  }

  file {
    "/etc/munin/htpasswd.users":
      owner => root,
      group => www-data,
      mode  => 0640,
      source => "puppet:///modules/puppetlabs/ops_htpasswd";
  }

  file {
    "/etc/apache2/htpasswd":
      ensure => absent;
  }

  # VPN for internal monitoring and DNS Resolution
  openvpn::client {
    "node_${hostname}_office":
      server => "office.puppetlabs.com",
      cert   => "node_${hostname}",
  }

  openvpn::client {
    "node_${hostname}_dc1":
      server => "vpn.puppetlabs.net",
      cert   => "node_${hostname}",
  }

  # DNS resolution to internal hosts
  include unbound
  unbound::stub { "puppetlabs.lan":
    address  => '192.168.100.1',
    insecure => true,
  }

  unbound::stub { "100.168.192.in-addr.arpa.":
    address  => '192.168.100.1',
    insecure => true,
  }

  unbound::stub { "dc1.puppetlabs.net":
    address  => '10.0.1.20',
    insecure => true,
  }

  unbound::stub { "42.0.10.in-addr.arpa.":
    address  => '10.0.1.20',
    insecure => true,
  }

  # zleslie: stop dhclient from updating resolve.conf
  file { "/etc/dhcp3/dhclient-enter-hooks.d/nodnsupdate":
    owner   => root,
    group   => root,
    mode    => 755,
    content => "#!/bin/sh\nmake_resolv_conf(){\n:\n}",
  }

  # Use unbound
  file { "/etc/resolv.conf":
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///modules/puppetlabs/local_resolv.conf";
  }

  nagios_host { "imana.puppetlabs.lan":
    ensure     => present,
    alias      => "imana",
    address    => "192.168.100.1",
    hostgroups => "office",
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify     => Service[$nagios::params::nagios_service],
  }

  nagios_service { "check_ping_imana":
    use                 => 'generic-service',
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "imana.puppetlabs.lan",
    service_description => "check_ping_imana.puppetlabs.lan",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  nagios_host { "vali.dc1.puppetlabs.net":
    ensure     => present,
    alias      => "vali",
    address    => "10.0.42.31",
    hostgroups => "dc1",
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify     => Service[$nagios::params::nagios_service],
  }

  nagios_host { "balder.dc1.puppetlabs.net":
    ensure     => present,
    alias      => "balder",
    address    => "10.0.42.32",
    hostgroups => "dc1",
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify     => Service[$nagios::params::nagios_service],
  }

  nagios_host { "eir.dc1.puppetlabs.net":
    ensure     => present,
    alias      => "eir",
    address    => "10.0.42.33",
    hostgroups => "dc1",
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify     => Service[$nagios::params::nagios_service],
  }

  nagios_service { "check_ping_vali":
    use                 => 'generic-service',
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "vali.dc1.puppetlabs.net",
    service_description => "check_ping_vali.dc1.puppetlabs.lan",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  nagios_service { "check_ping_balder":
    use                 => 'generic-service',
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "balder.dc1.puppetlabs.net",
    service_description => "check_ping_balder.dc1.puppetlabs.lan",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  nagios_service { "check_ping_eir":
    use                 => 'generic-service',
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => "eir.dc1.puppetlabs.net",
    service_description => "check_ping_eir.dc1.puppetlabs.lan",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

}

