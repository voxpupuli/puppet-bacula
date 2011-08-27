class puppetlabs::ningyo {

  ssh::allowgroup { "techops": }

  ###
  # Mysql
  #
  $mysql_root_pw = 'Vrs4ZnacNhr41v'
  include mysql::server

  ###
  # Puppet
  #
  sudo::entry{ "adrien":
    entry => "adrien ALL=(ALL) NOPASSWD: /usr/local/bin/puppet_deploy.rb\n",
  }

  $dashboard_site = 'dashboard.puppetlabs.com'

  $modulepath = [
    '$confdir/environments/$environment/site',
    '$confdir/environments/$environment/dist',
    '$confdir/global/imported',
  ]

  class { "puppet::server":
    modulepath => inline_template("<%= modulepath.join(':') %>"),
    dbadapter  => "mysql",
    dbuser     => "puppet",
    dbpassword => "M@gickF$ck!ngP@$$w0rddd!",
    dbsocket   => "/var/run/mysqld/mysqld.sock",
    reporturl  => "http://dashboard.puppetlabs.com/reports",
    servertype => "unicorn",
  }

  class { "puppet::dashboard":
    db_user => "dashboard",
    db_pw   => "8ksKjhds7yakjs",
    site    => "$dashboard_site",
    allowip => "173.255.196.32 96.126.118.85", # remove Nov 2011
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
      user => root,
      command => '(cd /usr/share/puppet-dashboard/; rake RAILS_ENV=production reports:prune -s upto=1 unit=mon > /dev/null)',
      minute => '20',
      hour => '2';
    "Puppet: puppet_deploy.rb":
      user    => root,
      command => '/usr/local/bin/puppet_deploy.rb',
      minute  => '*/8',
      require => File["/usr/local/bin/puppet_deploy.rb"];
  }

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

}

