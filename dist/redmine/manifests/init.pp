# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# I think I need to change this to download the latest version from git
#
class redmine {
  require git
  require rails
  require redmine::mysql
  include redmine::params
  $version = $redmine::params::version
  $source  = $redmine::params::source
  user{'redmine':
    ensure => 'present',
    shell  => '/bin/nologin',
  }
}
