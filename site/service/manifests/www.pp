class service::www {

  include postfix
  # MySQL
  $mysql_root_pw = 'K7DkG9TVfGke'
  include mysql::server

  package {'php5-curl': ensure => present, notify => Service[httpd] }

  bacula::job {
    "${fqdn}-www":
      files    => ["/var/lib/bacula/mysql","/var/www"],
  }

  # Add an nginx bouncer to speed up the apache sites on here.
  include nginx::server
  class { 'nginx::cache':
    port            => '80',
    upstream_server => 'localhost',
    upstream_port   => '82',
    priority        => '01',
  }

  ##################################################################
  # NOTE: Apache runs on port 82, nginx runs on port 80.
  # Get it right, or things break!
  $apache_port = '82'
  Apache::Vhost           { port => $apache_port }
  Apache::Vhost::Redirect { port => $apache_port }

  # WWW stuff
  # site for server itself
  apache::vhost {"$fqdn":
    docroot  => '/var/www',
    options  => "None",
    priority => '99';
  }

  # Hacked up apache configuration for nginx support.
  # LogFormat specifically so we can see the originating IP
  file {
    "/etc/apache2/apache2.conf":
      owner  => root,
      group  => root,
      mode   => 644,
      source => "puppet:///modules/puppetlabs/web01_apache2.conf";
  }

  # Some apache redirects, cause we love them
  apache::vhost::redirect {
    'puppetcon.com':
      serveraliases => "www.puppetcon.com",
      dest          => 'http://www.puppetconf.com';
    'blog.puppetlabs.com':
      dest          => 'http://www.puppetlabs.com/blog';
    'puppetcamp.org':
      serveraliases => "www.puppetcamp.org",
      dest          => 'http://www.puppetlabs.com/community/puppet-camp',
      status        => '301';
    'reductivelabs.com':
      serveraliases => "www.reductivelabs.com",
      dest          => 'http://www.puppetlabs.com',
      status        => '301';
    'marionette-collective.com':
      serveraliases => 'www.marionette-collective.com',
      dest          => 'http://docs.puppetlabs.com/mcollective',
      status        => '301';
    'marionette-collective.org':
      serveraliases => 'www.marionette-collective.org',
      dest          => 'http://docs.puppetlabs.com/mcollective',
      status        => '301';
  }

  # Wordpress Sites
  Wordpress::Instance { port => $apache_port }

  nagios::website { 'www.puppetlabs.com': }
  wordpress::instance {
    'puppetlabs.com':
      site_alias      => ["www.puppetlabs.com","dev.puppetlabs.com"],
      auth_key        => 'rspk1YxmxcUDIqhjH1pUQq59WCTvISTXlflU7UZoUFw8faCzNy1VC8Uq9sl0gxg',
      secure_auth_key => 'MJQKXGrbtSs4toOG2JsqjrYopYU9Ij9wQYX5kttycvTwEfc9uGFDxo6leeLCITL',
      logged_in_key   => 't7O5y1MW41ZT4jETgJkdCUn35f8fzQgfnZ9sivR4k8M5kU6U17I6GhA73NtLVLd',
      nonce_key       => 'ReRyvF7pScI6OAhGQaDaSgNnXsKBkutqshJxc2a4PRmXEDEVzNarEYJenhvDQIq',
      db_pw           => '5NuTnEFV9Hvp',
      db_user         => 'plabs',
      template        => 'puppetlabs/puppetlabs_vhost.conf.erb',
      priority        => '02',
      seturl          => true,
  }

  # Add magic to watch the wordpress/themes/etc for puppetlabs.com
  file{ '/usr/local/bin/git_magic_wordpress.sh':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/puppetlabs/git_magic_wordpress.sh',
  } ->
  cron{ 'commit_puppetlabs': 
    command     => '/usr/local/bin/git_magic_wordpress.sh',
    user        => 'root',
    minute      => '*/10',
    environment => 'MAILTO=markops@puppetlabs.com',
  }

  # 8631
  file { "/var/www/puppetlabs.com/google297ed9803f18b575.html":
    owner   => root,
    group   => root,
    mode    => 644,
    content => "google-site-verification: google297ed9803f18b575.html";
  }

  file { "/var/www/puppetlabs.com/sitemap.xml":
      ensure  => present,
      replace => no,
      owner   => root,
      group   => root,
      mode    => 777,
      source  => "puppet:///modules/puppetlabs/www/puppetlabs.com/sitemap.xml";
    "/var/www/puppetlabs.com/.htaccess":
      ensure  => present,
      replace => no,
      owner   => root,
      group   => root,
      mode    => 777,
      source  => "puppet:///modules/puppetlabs/puppetlabscom_htaccess";
    "/var/www/puppetlabs.com/robots.txt":
      ensure  => present,
      replace => no,
      owner   => root,
      group   => root,
      mode    => 777,
      source  => "puppet:///modules/puppetlabs/www/puppetlabs.com/robots.txt";
  }

  # Disable nagios for this, as it's not up yet.
  # nagios::website { 'puppetdevchallenge.com': }
  wordpress::instance {
    'puppetdevchallenge.com':
      site_alias => "www.puppetdevchallenge.com",
      db_pw      => 'az62VHwUbtCi',
      db_user    => 'pdchallange',
      template   => 'puppetlabs/wordpress_vhost.conf.erb',
      priority   => '06',
      seturl     => true,
  }

  nagios::website { 'puppetconf.com': }
  wordpress::instance {
    'puppetconf.com':
      site_alias => "www.puppetconf.com",
      db_pw      => 'TiR6znV9EmGj',
      db_user    => 'pconf',
      template   => 'puppetlabs/wordpress_vhost.conf.erb',
      priority   => '06',
      seturl     => true,
  }

}

