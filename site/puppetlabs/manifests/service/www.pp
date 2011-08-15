class puppetlabs::service::www {

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

  # WWW stuff
  # site for server itself
  apache::vhost {"$fqdn":
    port     => 82,
    docroot  => '/var/www',
    options  => "None",
    priority => '99';
  }

  # Hacked up apache configuration for nginx support
  file {
    "/etc/apache2/ports.conf":
      owner  => root,
      group  => root,
      mode   => 644,
      source => "puppet:///modules/puppetlabs/web01_ports.conf";
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
      port          => '82',
      dest          => 'http://www.puppetconf.com';
    'blog.puppetlabs.com':
      port          => '82',
      dest          => 'http://www.puppetlabs.com/blog';
    'puppetcamp.org':
      serveraliases => "www.puppetcamp.org",
      port          => '82',
      dest          => 'http://www.puppetlabs.com/community/puppet-camp';
    'reductivelabs.com':
      serveraliases => "www.reductivelabs.com",
      port          => '82',
      dest          => 'http://www.puppetlabs.com';
  }

  nagios::website { 'madstop.com': }
  wordpress::instance {
    'madstop.com':
      site_alias      => "www.madstop.com",
      auth_key        => 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o',
      secure_auth_key => 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne',
      logged_in_key   => '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ',
      nonce_key       => 'P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3',
      db_pw           => 'illYZbw108Ckle8Q',
      template        => 'puppetlabs/madstop_vhost.conf.erb',
      priority        => '07',
      port            => '82',
  }
  file { "/var/www/madstop.com/.htaccess": owner => root, group => root, mode => 644, source => "puppet:///modules/puppetlabs/madstop_htaccess"; }

  nagios::website { 'www.puppetlabs.com': }
  wordpress::instance {
    'puppetlabs.com':
      site_alias      => "www.puppetlabs.com",
      auth_key        => 'rspk1YxmxcUDIqhjH1pUQq59WCTvISTXlflU7UZoUFw8faCzNy1VC8Uq9sl0gxg',
      secure_auth_key => 'MJQKXGrbtSs4toOG2JsqjrYopYU9Ij9wQYX5kttycvTwEfc9uGFDxo6leeLCITL',
      logged_in_key   => 't7O5y1MW41ZT4jETgJkdCUn35f8fzQgfnZ9sivR4k8M5kU6U17I6GhA73NtLVLd',
      nonce_key       => 'ReRyvF7pScI6OAhGQaDaSgNnXsKBkutqshJxc2a4PRmXEDEVzNarEYJenhvDQIq',
      db_pw           => '5NuTnEFV9Hvp',
      db_user         => 'plabs',
      template        => 'puppetlabs/puppetlabs_vhost.conf.erb',
      priority        => '02',
      port            => '82',
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

  nagios::website { 'puppetdevchallenge.com': }
  wordpress::instance {
    'puppetdevchallenge.com':
      site_alias => "www.puppetdevchallenge.com",
      db_pw      => 'az62VHwUbtCi',
      db_user    => 'pdchallange',
      template   => 'puppetlabs/wordpress_vhost.conf.erb',
      priority   => '06',
      port       => '82',
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
      port       => '82',
      seturl     => true,
  }

}

