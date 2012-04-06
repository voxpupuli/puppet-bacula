class graphite::install {

  include graphite::params

  $graphitedir  = $graphite::params::graphitedir
  $graphiteuser = $graphite::params::graphiteuser

  file{ $graphitedir:
    ensure => directory,
    owner  => $graphiteuser,
    mode   => '0755',
  }


  #
  # Graphite Install

  Exec["download graphite"] -> Exec["extract graphite"] ~> Exec["install graphite"] ~> Exec["initialize db"]
  exec { "download graphite":
    command   => "/usr/bin/wget -O $graphite::params::webapp_dl_loc $graphite::params::webapp_dl_url",
    cwd       => "/usr/local/src",
    creates   => "/usr/local/src/$graphite::params::webapp_dl_loc",
    logoutput => on_failure,
  }

  exec { "extract graphite":
    command   => "/bin/tar -xzf $graphite::params::webapp_dl_loc",
    cwd       => '/usr/local/src',
    creates   => "/usr/local/src/graphite-web-${graphite::params::version}",
    logoutput => on_failure,
  }

  exec { "install graphite":
    command     => '/usr/bin/python setup.py install',
    cwd         => "/usr/local/src/graphite-web-${graphite::params::version}",
    refreshonly => true,
    require     => [ Package["python-django-tagging"],File[$graphitedir] ],
    logoutput   => on_failure,
  }

  exec { "initialize db":
    command     => '/usr/bin/python manage.py syncdb --noinput',
    cwd         => '/opt/graphite/webapp/graphite',
    environment => "PYTHONPATH=/opt/graphite/webapp",
    refreshonly => true,
    user        => $graphite::params::web_user,
    require     => [ Package["python-sqlite"], File[$graphitedir] ],
    logoutput => on_failure,
  }

  #
  # Carbon Install

  Exec["download carbon"] -> Exec["extract carbon"] ~> Exec["install carbon"]
  exec { "download carbon":
    command   => "/usr/bin/wget -O $graphite::params::carbon_dl_loc $graphite::params::carbon_dl_url",
    cwd       => "/usr/local/src",
    creates   => "/usr/local/src/$graphite::params::carbon_dl_loc",
    logoutput => on_failure,
  }

  exec { "extract carbon":
    command   => "/bin/tar -xzf $graphite::params::carbon_dl_loc",
    cwd       => '/usr/local/src',
    creates   => "/usr/local/src/carbon-${graphite::params::version}",
    logoutput => on_failure,
  }

  exec { "install carbon":
    command     => '/usr/bin/python setup.py install',
    cwd         => "/usr/local/src/carbon-${graphite::params::version}",
    refreshonly => true,
    require     => [ Package["python-twisted"],File[$graphitedir] ],
    logoutput   => on_failure,
  }

  #
  # Whisper install

  Exec["download whisper"] -> Exec["extract whisper"] ~> Exec["install whisper"]
  exec { "download whisper":
    command   => "/usr/bin/wget -O $graphite::params::whisper_dl_loc $graphite::params::whisper_dl_url",
    cwd       => "/usr/local/src",
    creates   => "/usr/local/src/$graphite::params::whisper_dl_loc",
    logoutput => on_failure,
  }

  exec { "extract whisper":
    command   => "/bin/tar -xzf $graphite::params::whisper_dl_loc",
    cwd       => '/usr/local/src',
    creates   => "/usr/local/src/whisper-${graphite::params::version}",
    logoutput => on_failure,
  }

  exec { "install whisper":
    command     => '/usr/bin/python setup.py install',
    cwd         => "/usr/local/src/whisper-${graphite::params::version}",
    refreshonly => true,
    logoutput   => on_failure,
    require     => File[$graphitedir],
  }

}
