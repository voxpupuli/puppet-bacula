class puppetlabs::www {

  #
  # THIS CLASS SHOULD BE DEPRECATED ONCE APU IS REMOVED
  # MOVE THINGS STILL NEEDED TO Class["puppetlabs::service::www"]
  # REMOVE CAREFULLY!
  #

  # Nagios
#nagios::website { 'www.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::puppet

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = 'MQI/vywQq5pSlAYaEUJKrmt24Wu8FOIPfT7tFoaOc5X6'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  # added for temporary measure for transition away from apu
  bacula::job {
    "${fqdn}-www":
      files    => ["/var/lib/bacula/mysql","/var/www"],
      excludes => ["/var/www/puppetlabs.com/downloads"],
  }

  # Training downloads
  file {
    "/var/www/puppetlabs.com/downloads":
      owner    => root,
      group    => release,
      mode     => 664,
      recurse  => true,
      checksum => none;
    "/var/www/puppetlabs.com/downloads/training/current-pm-vm.tar.gz":
      ensure   => link,
      target   => "centos-5.5-pe-1.0.tar.gz";
    "/var/www/puppetlabs.com/downloads/training/current-pm-vm.tar.gz.md5":
      ensure   => link,
      target   => "centos-5.5-pe-1.0.tar.gz.md5";
    "/var/www/puppetlabs.com/downloads/training/current-pm-vm-ovf.tar.gz":
      ensure   => link,
      target   => "centos-5.5-pe-1.0-ovf.tar.gz";
    "/var/www/puppetlabs.com/downloads/training/current-pm-vm-ovf.tar.gz.md5":
      ensure   => link,
      target   => "centos-5.5-pe-1.0-ovf.tar.gz.md5";
  }

  # Mysql
  $mysql_root_pw = 'afmesackjebhee'
  include mysql::server
  include postfix

  apache::vhost::redirect {
    'blog.puppetlabs.com':
      port       => '80',
      dest       => 'http://www.puppetlabs.com/blog';
    'puppetcamp.org':
      serveraliases => "www.puppetcamp.org",
      port          => '80',
      dest          => 'http://www.puppetlabs.com/community/puppet-camp';
    'reductivelabs.com':
      serveraliases => "www.reductivelabs.com",
      port          => '80',
      dest          => 'http://www.puppetlabs.com';
  }

  wordpress::instance {
    'puppetlabs.com':
      site_alias      => "www.puppetlabs.com",
      auth_key        => 'rspk1YxmxcUDIqhjH1pUQq59WCTvISTXlflU7UZoUFw8faCzNy1VC8Uq9sl0gxg',
      secure_auth_key => 'MJQKXGrbtSs4toOG2JsqjrYopYU9Ij9wQYX5kttycvTwEfc9uGFDxo6leeLCITL',
      logged_in_key   => 't7O5y1MW41ZT4jETgJkdCUn35f8fzQgfnZ9sivR4k8M5kU6U17I6GhA73NtLVLd',
      nonce_key       => 'ReRyvF7pScI6OAhGQaDaSgNnXsKBkutqshJxc2a4PRmXEDEVzNarEYJenhvDQIq',
      db_pw           => 'X2i8nRTE',
      template        => 'puppetlabs/puppetlabs_vhost.conf.erb',
  }

  package {'php5-curl': ensure => present, notify => Service[httpd] }
  realize(A2mod['headers'])
  realize(A2mod['expires'])

}

