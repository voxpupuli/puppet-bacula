# = Class: gitolite::package
#
# Backports requires the backports repo available. Fo shizzle.
class gitolite::package($source = hiera('gitolite_package_source')) {

  case $source {
    'backports': {
      apt::force { 'gitolite':
        release => 'squeeze-backports',
      }
    }
    default: {
      package { 'gitolite':
        ensure => present,
      }
    }
  }
}
