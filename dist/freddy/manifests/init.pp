class freddy($root = '/opt/freddy') {

  vcsrepo { $root:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/stepchange/freddy',
    revision => 'd30a0e3dd9588a0fdbc312139c544d2223c07485',
  }

  file { "${root}/public":
    ensure => directory,
  }

  file { "${root}/config.ru":
    ensure => present,
    source => "puppet:///modules/freddy/config.ru",
  }
}
