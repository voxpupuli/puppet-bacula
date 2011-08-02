# Class: okra
#
# Installs the okra rails app and all dependencies
#
# Actions:
#
# clones the github url
#
# Sample Usage:
#
class okra {
  include git
  include okra::params

  user { "okra":
    ensure => present,
  }

  vcsrepo { $okra::params::basedir:
    ensure   => present,
    provider => git,
    source   => $okra::params::source_url
  }
}
