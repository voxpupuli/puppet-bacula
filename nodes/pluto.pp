node pluto {
  include role::server

  ssh::allowgroup { "developers": }
  ssh::allowgroup { "prosvc": }
  ssh::allowgroup { "builder": }

  sudo::allowgroup { "builder": }

  # Customer Groups
  Account::User <| tag == customer |>
  Group <| tag == customer |>

  $ssh_customer = [
    "vmware",
    "motorola",
    "nokia",
    "blackrock",
    "secureworks",
    "bioware",
    "wealthfront",
    "scea",
    "advance"
  ]

  ssh::allowgroup { $ssh_customer: chroot => true; }

  Account::User <| tag == deploy |>
  Account::User <| tag == deploy |>
  ssh::allowgroup { "www-data": }

  # Enterprise
  package { "daemontools": ensure => installed; }
  cron { "sync /opt/enterprise to tbdriver":
    minute  => '*/10',
    user    => root,
    command => '/usr/bin/setlock -nx /var/run/_opt_enterprise_sync.lock /usr/local/bin/_opt_enterprise_sync.sh';
  }

  file { "/usr/local/bin/_opt_enterprise_sync.sh":
    owner  => root,
    group  => root,
    mode   => 750,
    source => "puppet:///modules/puppetlabs/_opt_enterprise_sync.sh";
  }

  # Crypt filesystem
  package { "cryptsetup": ensure => installed; }
  exec    { "/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4": creates => '/var/chroot.key'; }
  file    { "/var/chroot.key": mode => 0400, require => Exec["/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4"]; }

  apache::vhost {
    "$fqdn":
      port    => 80,
      docroot => '/opt/enterprise'
  }

  file {
    "/opt/enterprise":
      owner   => root,
      group   => enterprise,
      mode    => 0664,
      recurse => true;
    "/opt/puppet":
      ensure  => directory,
      owner   => root,
      group   => www-data,
      mode    => 0664,
      recurse => true;
    "/opt/puppet/nightly":
      ensure  => directory,
      owner   => root,
      group   => www-data,
      mode    => 0664;
    "/opt/tools":
      ensure  => directory,
      owner   => root,
      group   => developers,
      mode    => 664,
      recurse => true;
  }

  include apt::backports
  class { 'freight':
    freight_vhost_name  => 'freight.puppetlabs.lan',
    freight_docroot     => '/opt/enterprise/repos/debian',
    freight_gpgkey      => 'pluto@puppetlabs.lan',
    freight_group       => 'enterprise',
    freight_libdir      => '/opt/tools/freight',
  }

}

