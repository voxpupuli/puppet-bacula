class graphite (
    $site_alias = $fqdn
  ) {

# TODO:
#  /opt/graphite/conf/carbon.conf
#  /opt/graphite/conf/storage-schemas.conf
#  /opt/graphite/conf/dashboard.conf

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

#  file { "/opt/graphite/storage":
#    owner     => $graphite::params::web_user,
#    subscribe => Exec["install-webapp"],
#    recurse   => inf
#  }

}

