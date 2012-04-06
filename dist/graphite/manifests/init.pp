class graphite (
    $site_alias = $fqdn
  ) {

  include graphite::install
  include graphite::params

  $graphitedir  = $graphite::params::graphitedir
  $graphiteuser = $graphite::params::graphiteuser


  include apache::mod::wsgi
  include apache::mod::python
  include django

  package { "python-cairo":    ensure => installed; }
  package { "python-memcache": ensure => installed; }
  package { "python-sqlite":   ensure => installed; }
  package { "python-twisted":  ensure => installed; }
  package { "python-django-tagging":  ensure => installed; }
  package { "memcached":       ensure => installed; }

  user{ $graphiteuser:
    system     => true,
    ensure     => present,
    gid        => $graphite::params::graphitegroup,
    managehome => false,
    home       => $graphitedir,
    before     => Class['graphite::install'],
  }

  apache::vhost {"$site_alias":
    port     => '80',
    docroot  => '/var/www',
    ssl      => false,
    priority => 10,
    template => 'graphite/apache.conf.erb',
    require  => Exec["install graphite"],
  }

  file { "${graphitedir}/conf/graphite.wsgi":
    source    => "${graphitedir}/conf/graphite.wsgi.example",
    mode      => '0644',
    owner     => $graphiteuser,
    subscribe => Exec["install graphite"],
    require   => [ User[$graphiteuser],Exec["install graphite"] ],
  }

  file { "${graphitedir}/storage":
    owner     => $graphite::params::web_user,
    group     => $graphite::params::graphitegroup,
    mode      => '0664',
    subscribe => Exec["install graphite"],
    recurse   => true,
    require   => [ User[$graphiteuser],Exec["install graphite"] ],
  }

  file { "${graphitedir}/conf/carbon.conf":
    source    => "puppet:///modules/graphite/carbon.conf",
    mode      => '0644',
    owner     => $graphiteuser,
    subscribe => Exec["install carbon"],
    require   => [ User[$graphiteuser],Exec["install carbon"] ],
  }

  file { "${graphitedir}/conf/storage-schemas.conf":
    source    => "puppet:///modules/graphite/storage-schemas.conf",
    owner     => $graphiteuser,
    mode      => '0644',
    subscribe => Exec["install carbon"],
    require   => [ User[$graphiteuser],Exec["install carbon"] ],
  }

  file { "${graphitedir}/conf/dashboard.conf":
    source    => "puppet:///modules/graphite/dashboard.conf",
    owner     => $graphiteuser,
    mode      => '0644',
    subscribe => Exec["install graphite"],
    require   => [ User[$graphiteuser], Exec["install graphite"] ],
  }

  file{ '/var/log/graphite':
    target => '/opt/graphite/storage/log/',
    ensure => link
  }

  exec { "remove stale carbon-cache pidfile":
    command => "rm ${graphitedir}/storage/carbon-cache-a.pid",
    path    => ["/usr/bin", "/bin"],
    unless  => "pgrep carbon-cache.py || test ! -f ${graphitedir}/storage/carbon-cache-a.pid",
  }

  file { '/etc/init.d/carbon':
    source    => "puppet:///modules/graphite/carbon_initscript",
    owner     => 'root',
    mode      => '0755',
    ensure    => file,
    require   => User[$graphiteuser],
  }

   service { 'carbon':
     ensure     => running,
     enable     => true,
     hasrestart => true,
     hasstatus  => true,
     require    => [
      File["${graphitedir}/conf/carbon.conf"],
      File['/etc/init.d/carbon'],
      Exec["install whisper"],
      Exec["remove stale carbon-cache pidfile"],
    ],
  }

  bacula::job {
    "${fqdn}-graphite":
      files => ["${graphitedir}"],
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

