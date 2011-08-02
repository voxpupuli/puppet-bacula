# Class: okra::package
#
# Clones okra and installs all dependencies
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class okra::package {
  include git

  #vcsrepo { $okra::params::basedir:
  #  ensure   => present,
  #  provider => git,
  #  source   => $okra::params::source_url
  #}
}
