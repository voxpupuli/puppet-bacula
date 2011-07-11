class puppetlabs::burji {

  include puppetlabs_ssl

  # User Stuff
  #
  ssh::allowgroup  { "release":    }
  ssh::allowgroup  { "prosvc":     }
  ssh::allowgroup  { "enterprise": }

  sudo::allowgroup { "release":    }

  # Server stuff
  #
  Package <| title == 'mlocate' |>

  $ssl_path = $puppetlabs_ssl::params::ssl_path

  include puppetlabs::service::pkgrepo

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  # Sites
  nagios::website { 'pm.puppetlabs.com': }
  nagios::website { 'ps.puppetlabs.com': }

  file { "/var/www/index.html": ensure => absent; }

  apache::vhost {
    "$fqdn":
      port    => 80,
      options => "None",
      docroot => '/var/www'
  }

  # http://ps.puppetlabs.com
  #
  apache::vhost::redirect {
    'ps.puppetlabs.com':
      port => '80',
      dest => 'https://ps.puppetlabs.com',
  }

  apache::vhost {
    'ps.puppetlabs.com_ssl':
      serveraliases => "ps.puppetlabs.com",
      port          => '443',
      docroot       => '/opt/prosvc',
      ssl           => true,
      auth          => true,
      priority      => 11,
      template      => 'puppetlabs/legba.conf.erb';
  }

  file { "/opt/prosvc":
    ensure   => directory,
    owner    => root,
    group    => prosvc,
    mode     => 0664,
    recurse  => true,
    checksum => none;
  }
  file { "/opt/prosvc/.htaccess": ensure => absent; }

  # http://pm.puppetlabs.com
  #
  apache::vhost::redirect {
    'pm.puppetlabs.com':
      port => '80',
      dest => 'https://pm.puppetlabs.com',
  }

  apache::vhost {
    'pm.puppetlabs.com_ssl':
      serveraliases => "pm.puppetlabs.com",
      port          => 443,
      docroot       => '/opt/pm',
      ssl           => true,
      auth          => false,
      priority      => 16,
      template      => 'puppetlabs/legba.conf.erb';
  }

  file { "/opt/pm":
    ensure   => directory,
    owner    => root,
    group    => enterprise,
    mode     => 664,
    recurse  => true,
    checksum => none;
  }

  file { "/opt/pm/.htaccess":
    owner  => root,
    group  => enterprise,
    mode   => 644,
    source => "puppet:///modules/puppetlabs/legba_htaccess";
  }

  apache::vhost {
    "downloads.puppetlabs.com":
      port    => 80,
      docroot => '/opt/downloads'
  }

}

