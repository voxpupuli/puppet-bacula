node ningyo {

  include role::server

  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }
  ssh::allowgroup { "infra": }

  # ---
  # Mysql
  # --
  $mysql_root_pw = 'Vrs4ZnacNhr41v'
  include mysql::server

  # ---
  # Puppet
  # ---
  sudo::entry { "ssvarma": entry => "ssvarma ALL=(ALL) NOPASSWD: /usr/local/bin/puppet_deploy.rb\n"; }
  sudo::entry { "infra": entry => "%infra ALL=(ALL) NOPASSWD: /usr/local/bin/puppet_deploy.rb\n"; }

  $dashboard_site = 'dashboard.puppetlabs.com'

  $modulepath = [
    '$confdir/environments/$environment/site',
    '$confdir/environments/$environment/dist',
    '$confdir/global/imported',
  ]

  # Hiera configuration
  package { "hiera":        ensure => installed, provider => gem; }
  package { "hiera-puppet": ensure => installed, provider => gem; }

  file {
    "/etc/puppet/hiera.yaml":
      source => "puppet:///modules/puppetlabs/hiera.yaml";
  }

  file {
    "/etc/hiera.yaml":
      ensure  => link,
      target  => "/etc/puppet/hiera.yaml",
      require => File["/etc/puppet/hiera.yaml"]
  }

  class { "puppet::server":
    modulepath   => inline_template("<%= modulepath.join(':') %>"),
    storeconfigs => "grayskull",
    reporturl    => "https://dashboard.puppetlabs.com/reports",
    servertype   => "unicorn",,
    manifest     => '$confdir/environments/$environment/site.pp',
    reports      => ["store", "https", "xmpp"],
  }

  class { "puppet::dashboard":
    db_user   => "dashboard",
    db_pw     => "8ksKjhds7yakjs",
    site      => "$dashboard_site",
    allowip   => "173.255.196.32 96.126.118.85", # remove Nov 2011
    appserver => "unicorn",
  }

  include puppet::server::xmppreport

  nginx::vhost::redirect{
    'dashboard_to_ssl':
      servername => 'dashboard.puppetlabs.com',
      priority   => '49',
      port       => '80',
      ssl        => false,
      dest       => 'https://dashboard.puppetlabs.com/',
  }

  file {
    "/usr/local/bin/puppet_deploy.rb":
      owner => root,
      group => root,
      mode  => 0750,
      source => "puppet:///modules/puppetlabs/puppet_deploy.rb";
    ['/etc/puppet/global', '/etc/puppet/global/imported']:
      ensure => directory,
      mode   => 0755,
      owner  => 'root',
      group  => 'root',
      before => Class['puppet::server'];
  }

  file {
    "/etc/nginx/htpasswd":
      owner => root,
      group => www-data,
      mode  => 0640,
      source => "puppet:///modules/puppetlabs/ops_htpasswd";
  }

  file {
    "/etc/apache2/htpasswd":
      ensure => absent;
  }

  cron {
    "compress_reports":
      user    => root,
      command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml" -mtime +1 -exec gzip {} \;',
      minute => '9';
    "clean_old_reports":
      user => root,
      command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml.gz" -mtime +14 -exec rm {} \;',
      minute => '0',
      hour => '2';
    "clean_dashboard_reports":
      user    => root,
      command => '(cd /usr/share/puppet-dashboard/ && rake --silent RAILS_ENV=production reports:prune upto=1 unit=mon >/dev/null)',
      minute  => '20',
      hour    => '2';
    'optimise_dashboard_db':
      user    => root,
      command => '(cd /usr/share/puppet-dashboard/ && rake --silent RAILS_ENV=production db:raw:optimize >/dev/null )',
      minute  => '42',
      hour    => '2';
    "Puppet: puppet_deploy.rb":
      user    => root,
      command => '/usr/local/bin/puppet_deploy.rb 2>/dev/null',
      minute  => '*/8',
      require => File["/usr/local/bin/puppet_deploy.rb"];
  }

  file { "/var/lib/puppet/moduledata":
    ensure => directory,
    owner  => puppet,
    mode   => 0700,
  }

  include grayskull

}

