# = Node: burji
#
# == Description
#
# This node hosts downloads for puppet products, so such things as
# yum.puppetlabs.com, apt.puppetlabs.com, downloads.puppetlabs.com, and other
# roles.
#
# This host should be accessible to anyone that needs to administer releases,
# such as the enterprise release team, solutions, and professional services.
#
# == Other names
#
# - downloads.puppetlabs.com
# - apt.puppetlabs.com
# - yum.puppetlabs.com
node burji {
  include role::server
  include service::docs
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

  include service::pkgrepo

  # Sites
  nagios::website { 'pm.puppetlabs.com': }
  nagios::website { 'ps.puppetlabs.com': }

  file { "/var/www/index.html": ensure => absent; }

  apache::vhost { $fqdn:
    port    => 80,
    options => "None",
    docroot => '/var/www'
  }

  # http://ps.puppetlabs.com
  #
  apache::vhost::redirect { 'ps.puppetlabs.com':
    port => '80',
    dest => 'https://ps.puppetlabs.com',
  }

  apache::vhost { 'ps.puppetlabs.com_ssl':
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

  apache::vhost { 'pm.puppetlabs.com_ssl':
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

  apache::vhost {
    "downloads.puppetlabs.com_ssl":
      servername => 'downloads.puppetlabs.com',
      priority   => '99',
      ssl        => true,
      port       => 443,
      docroot    => '/opt/downloads',
      template   => 'apache/vhost-default-ssl.conf.erb',
  }

  file { "/opt/downloads":
    owner    => deploy,
    group    => release,
    mode     => 664,
    recurse  => true,
    checksum => none,
    ignore   => 'training',
  }

  file{ '/opt/downloads/training':
    group    => 'prosvc',
    mode     => 664,
    recurse  => true,
    checksum => none,
  }

  $puppet_link_version = "2.7.9"
  file { # puppet links
    "/opt/downloads/puppet/puppet-latest.tar.gz":
      ensure => link,
      target => "puppet-${puppet_link_version}.tar.gz";
    "/opt/downloads/puppet/puppet-latest.tgz":
      ensure => link,
      target => "puppet-${puppet_link_version}.tar.gz";
    "/opt/downloads/puppet/puppet-latest.tar.gz.asc":
      ensure => link,
      target => "puppet-${puppet_link_version}.tar.gz.asc";
    "/opt/downloads/puppet/puppet-latest.tgz.asc":
      ensure => link,
      target => "puppet-${puppet_link_version}.tar.gz.asc";
  }

  file { '/opt/tools':
    ensure    => directory,
    group     => 'release',
    require   => Group['release'],
    mode      => 0775,
  }

  file { '/opt/repository/incoming':
    ensure    => directory,
    group     => 'release',
    require   => Group['release'],
    mode      => 0775,
  }

  freight::repo { 'community':
    freight_vhost_name       => 'apt.puppetlabs.com',
    freight_docroot          => '/opt/repository/apt',
    freight_gpgkey           => 'info@puppetlabs.com',
    freight_group            => 'release',
    freight_libdir           => '/opt/tools/freight',
    freight_manage_libdir    => true,
    freight_manage_docroot   => true,
    freight_manage_vhost     => true,
    freight_manage_ssl_vhost => true,
  }
  
  s3cmd::backup_dir {'burji_opt_pm': 
    bucket        => "burji",
    config_file   => "/root/.s3cfg",
    dir_to_backup => '/opt/pm',
    user          => 'root',
    ensure        => 'present',
    minute        => 0,
    hour          => 0,
    weekday       => 0,
 }

  s3cmd::backup_dir {'burji_opt_downloads':
    bucket        => "burji",
    config_file   => "/root/.s3cfg",
    dir_to_backup => '/opt/downloads',
    user          => 'root',
    ensure        => 'present',
    minute        => 0,
    hour          => 4,
    weekday       => 0, 
 }

}

