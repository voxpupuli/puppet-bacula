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


  package{ 'rubygems-update': ensure => installed, provider => gem }
  exec{ 'updaterubygems':
    command => '/var/lib/gems/1.8/bin/update_rubygems',
    unless  => '/usr/bin/gem env  | /bin/egrep -q "RUBYGEMS VERSION: 1.([456789]\.[0-9][0-9]?[0-9]?|3\.[6789][0-9]?)"',
    require => Package['rubygems-update']}

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
  package{ 'dm-sqlite-adapter':
    ensure   => installed,
    provider => gem,
    require  => Package['libsqlite3-dev'],
  }

  package { [ 'json', 'data_mapper', 'dm-adjust', 'sinatra', 'httpclient' ]:
    ensure   => installed,
    provider => gem,
    require  => Exec['updaterubygems']
  }

  file{ '/var/run/tally/': ensure => directory, group => 'nogroup', mode => '0770' }

  unicorn::app{ 'tally':
   approot         =>  '/opt/tally/',
   unicorn_pidfile => '/var/run/tally/tally.pid',
   unicorn_socket  => 'http://192.168.100.127:6666',
   rack_file       => '/opt/tally/config.ru',
   require         => [ File['/var/run/tally'], Vcsrepo['/opt/tally'], ],
  }

}
