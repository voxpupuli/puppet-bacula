class graphite::legacy::install {

  include graphite::legacy::params

  #
  # Graphite Install

  Exec["download graphite"] -> Exec["extract graphite"] ~> Exec["install graphite"] ~> Exec["initialize db"]
  exec { "download graphite":
    command => "/usr/bin/wget -O $graphite::legacy::params::webapp_dl_loc $graphite::legacy::params::webapp_dl_url",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/$graphite::legacy::params::webapp_dl_loc";
  }

  exec { "extract graphite":
    command => "/bin/tar -xzf $graphite::legacy::params::webapp_dl_loc",
    cwd     => '/usr/local/src',
    creates => "/usr/local/src/graphite-web-${graphite::legacy::params::version}",
  }

  exec { "install graphite":
    command     => '/usr/bin/python setup.py install',
    cwd         => "/usr/local/src/graphite-web-${graphite::legacy::params::version}",
    refreshonly => true,
    require     => Package["python-django-tagging"],
  }

  exec { "initialize db":
    command     => '/usr/bin/python manage.py syncdb --noinput',
    cwd         => '/opt/graphite/webapp/graphite',
    environment => "PYTHONPATH=/opt/graphite/webapp",
    refreshonly => true,
    user        => $graphite::legacy::params::web_user,
    require     => Package["python-sqlite"],
  }

  #
  # Carbon Install

  Exec["download carbon"] -> Exec["extract carbon"] ~> Exec["install carbon"]
  exec { "download carbon":
    command => "/usr/bin/wget -O $graphite::legacy::params::carbon_dl_loc $graphite::legacy::params::carbon_dl_url",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/$graphite::legacy::params::carbon_dl_loc";
  }

  exec { "extract carbon":
    command => "/bin/tar -xzf $graphite::legacy::params::carbon_dl_loc",
    cwd     => '/usr/local/src',
    creates => "/usr/local/src/carbon-${graphite::legacy::params::version}",
  }

  exec { "install carbon":
    command     => '/usr/bin/python setup.py install',
    cwd         => "/usr/local/src/carbon-${graphite::legacy::params::version}",
    refreshonly => true,
    require     => Package["python-twisted"],
  }

  #
  # Whisper install

  Exec["download whisper"] -> Exec["extract whisper"] ~> Exec["install whisper"]
  exec { "download whisper":
    command => "/usr/bin/wget -O $graphite::legacy::params::whisper_dl_loc $graphite::legacy::params::whisper_dl_url",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/$graphite::legacy::params::whisper_dl_loc";
  }

  exec { "extract whisper":
    command => "/bin/tar -xzf $graphite::legacy::params::whisper_dl_loc",
    cwd     => '/usr/local/src',
    creates => "/usr/local/src/whisper-${graphite::legacy::params::version}",
  }

  exec { "install whisper":
    command => '/usr/bin/python setup.py install',
    cwd     => "/usr/local/src/whisper-${graphite::legacy::params::version}",
    refreshonly => true;
  }

}
