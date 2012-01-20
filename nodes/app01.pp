node app01 {
  include role::server
  include patchwork

  ssh::allowgroup { "developers": }
  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }

  # https://projects.puppetlabs.com/issues/7849
  # github pull request robot
  # THIS DOESN'T WORK, VCSREPO IS UTTER MONKEY SHIT.
  class{ 'githubrobotpuller':
    version => 'bd4ea8f52b66556a1d45c03f9ff975e09f6b16e2',
  }



  # 11924 - Triage-a-thon site
  vcsrepo { '/opt/tally':
    source   => 'https://github.com/jamtur01/tally.git',
    provider => git,
    owner    => 'nobody',
    group    => 'nogroup',
  }

  package{ 'libsqlite3-dev':
    ensure => installed,
  }

  package { [ 'json', 'data_mapper', 'dm-sqlite-adapter', 'dm-adjust', 'sinatra', 'httpclient' ]:
    ensure   => installed,
    provider => gem,
    require  => Package['libsqlite3'],
  }

  file{ '/var/run/tally/': ensure => directory, group => 'nogroup', mode => '0770' }

  unicorn::app{ 'tally':
   approot         =>  '/opt/tally/',
   unicorn_pidfile => '/var/run/tally/tally.pid',
   unicorn_socket  => 'http://192.168.100.127:6666',
   rack_file       => '/opt/tally/config.ru',
   require         => File['/var/run/tally'],
  }

}
