class freddy($root = '/opt/freddy') {

  include apache

  vcsrepo { $root:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/stepchange/freddy',
    revision => 'd30a0e3dd9588a0fdbc312139c544d2223c07485',
  }
}
