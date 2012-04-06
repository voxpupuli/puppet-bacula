class graphite::legacy (
    $site_alias = $fqdn
  ) {

  include graphite::legacy::install

  include apache::mod::wsgi
  include apache::mod::python
  include django

  package { "python-cairo":    ensure => installed; }
  package { "python-memcache": ensure => installed; }
  package { "python-sqlite":   ensure => installed; }
  package { "python-twisted":  ensure => installed; }
  package { "python-django-tagging":  ensure => installed; }
  package { "memcached":       ensure => installed; }

  apache::vhost {"$site_alias":
    port     => '80',
    docroot  => '/var/www',
    ssl      => false,
    priority => 10,
    template => 'graphite/apache.conf.erb',
    require  => Exec["install graphite"],
  }

  file { "/opt/graphite/conf/graphite.wsgi":
    source    => "/opt/graphite/conf/graphite.wsgi.example",
    subscribe => Exec["install graphite"],
  }

  file { "/opt/graphite/storage":
    owner     => $graphite::legacy::params::web_user,
    subscribe => Exec["install graphite"],
    recurse   => true
  }

  file { "/opt/graphite/conf/carbon.conf":
    source    => "puppet:///modules/graphite/carbon.conf",
    subscribe => Exec["install carbon"],
  }

  file { "/opt/graphite/conf/storage-schemas.conf":
    source    => "puppet:///modules/graphite/storage-schemas.conf",
    subscribe => Exec["install carbon"],
  }

  file { "/opt/graphite/conf/dashboard.conf":
    source    => "puppet:///modules/graphite/dashboard.conf",
    subscribe => Exec["install graphite"],
  }

  exec { "remove stale carbon-cache pidfile":
    command => "rm /opt/graphite/storage/carbon-cache-a.pid",
    path    => ["/usr/bin", "/bin"],
    unless  => "pgrep carbon-cache.py || test ! -f /opt/graphite/storage/carbon-cache-a.pid",
  }

  service { "carbon-cache":
    ensure     => running,
    hasrestart => false,
    hasstatus  => true,
    stop       => "/opt/graphite/bin/carbon-cache.py stop",
    start      => "/opt/graphite/bin/carbon-cache.py start",
    status     => "/opt/graphite/bin/carbon-cache.py status",
    require    => [
      File["/opt/graphite/conf/carbon.conf"],
      Exec["install whisper"],
      Exec["remove stale carbon-cache pidfile"],
    ],
  }

  bacula::job {
    "${fqdn}-graphite":
      files => ["/opt/graphite"],
  }

  cron { "remove ancient graphite log files":
    command => "/usr/bin/find /opt/graphite/storage/log -type f -mtime +14 | /usr/bin/xargs -I {} rm {}",
    user    => root,
    minute  => 18,
    hour    => 4,
    weekday => 3;
  }

  cron { "compress oldish graphite log files":
    command => '/usr/bin/find /opt/graphite/storage/log -type f -mtime +3 -regex ".*[^.gz$]" | /usr/bin/xargs -I {} /usr/bin/nice -n 19 /usr/bin/ionice -c3 gzip {}',
    user    => root,
    minute  => 41,
    hour    => 4,
    weekday => 3;
  }


}

