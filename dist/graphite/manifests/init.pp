class graphite (
    $site_alias = $fqdn
  ) {

  include graphite::install

  include apache::mod::wsgi
  include apache::mod::python
  include django

  package { "python-cairo":    ensure => installed; }
  package { "python-memcache": ensure => installed; }
  package { "python-sqlite":   ensure => installed; }
  package { "memcached":       ensure => installed; }

  apache::vhost {"$site_alias":
    port     => '80',
    docroot  => '/var/www',
    ssl      => false,
    priority => 10,
    template => 'graphite/apache.conf.erb',
  }

  file { "/opt/graphite/conf/graphite.wsgi":
    source    => "/opt/graphite/conf/graphite.wsgi.example",
    subscribe => Exec["install graphite"],
  }

  file { "/opt/graphite/storage":
    owner     => $graphite::params::web_user,
    subscribe => Exec["install graphite"],
    recurse   => true
  }

  file { "/opt/graphite/conf/carbon.conf":
    source    => "puppet:///modules/graphite/carbon.conf",
    subscribe => Exec["install graphite"],
  }

  file { "/opt/graphite/conf/storage-schemas.conf":
    source    => "puppet:///modules/graphite/storage-schemas.conf",
    subscribe => Exec["install graphite"],
  }

  file { "/opt/graphite/conf/dashboard.conf":
    source    => "puppet:///modules/graphite/dashboard.conf",
    subscribe => Exec["install graphite"],
  }

  bacula::job {
    "${fqdn}-graphite":
      files => ["/opt/graphite"],
  }

}

