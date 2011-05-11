class graphite {


# TODO:
  /opt/graphite/conf/carbon.conf
  /opt/graphite/conf/storage-schemas.conf
  /etc/apache2/sites-available/graphite.conf





  package { "apache2": ensure => installed; }
  package { "libapache2-mod-wsgi": ensure => installed; }
  package { "python": ensure => installed; }
  package { "python-django": ensure => installed; }
  package { "python-cairo": ensure => installed; }
  package { "libapache2-mod-python": ensure => installed; }
  package { "python-memcache": ensure => installed; }
  package { "python-sqlite": ensure => installed; }
  package { "memcached": ensure => installed; }
  package { "libapache2-mod-wsgi": ensure => installed; }

  # gather project
  package { "libxml-simple-perl": ensure => installed; }

  #
  # Graphite Install

  Exec["pull graphite"] -> Exec["extract graphite"]
  exec { "pull graphite":
    command => '/usr/bin/wget "http://launchpad.net/graphite/1.0/0.9.8/+download/graphite-web-0.9.8.tar.gz"',
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/graphite-web-0.9.8.tar.gz";
  }

  exec { "extract graphite":
    command => '/bin/tar -xzf graphite-web-0.9.8.tar.gz',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/graphite-web-0.9.8',
  }

  exec { "install graphite":
    command => '/usr/bin/python setup.py install',
    cwd     => '/usr/local/src/graphite-0.9.8',
    creates => '/opt/graphite/webapp',
  }

  #
  # Carbon Install

  Exec["pull carbon"] -> Exec["extract carbon"]
  exec { "pull carbon":
    command => '/usr/bin/wget "http://launchpad.net/graphite/1.0/0.9.8/+download/carbon-0.9.8.tar.gz"',
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/carbon-0.9.8.tar.gz";
  }

  exec { "extract carbon":
    command => '/bin/tar -xzf carbon-0.9.8.tar.gz',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/carbon-0.9.8',
  }

  exec { "install carbon":
    command => '/usr/bin/python setup.py install',
    cwd     => '/usr/local/src/carbon-0.9.8',
    creates => '/opt/graphite/lib/carbon',
  }

  #
  # Whisper install

  Exec["pull whisper"] -> Exec["extract whisper"] -> Exec["install whisper"]
  exec { "pull whisper":
    command => '/usr/bin/wget "http://launchpad.net/graphite/1.0/0.9.8/+download/whisper-0.9.8.tar.gz"',
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/whisper-0.9.8.tar.gz";
  }

  exec { "extract whisper":
    command => '/bin/tar -xzf whisper-0.9.8.tar.gz',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/whisper-0.9.8',
  }

  exec { "install whisper":
    command => '/usr/bin/python setup.py install',
    cwd     => '/usr/local/src/whisper-0.9.8',
    creates => '/usr/local/bin/whisper-info.py',
  }


}
