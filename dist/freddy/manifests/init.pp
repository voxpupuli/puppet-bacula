class freddy($root = '/opt/freddy') {

  require sinatra

  vcsrepo { $root:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/djsauble2/freddy',
    revision => '6b494e6b29378f52cb2b081cf7e1efc2e180423f',
  }

  file { "${root}/public":
    ensure => directory,
  }

  file { "${root}/config.ru":
    ensure => present,
    source => "puppet:///modules/freddy/config.ru",
  }
}
