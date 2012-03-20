# = Class: gitolite::install
#
# Backports requires the backports repo available. Fo shizzle.
class gitolite::install($source = hiera('gitolite_install_source')) {

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
