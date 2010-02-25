# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# I think I need to change this to download the latest version from git
#
class redmine {
  include redmine::params
  $rails_version=$redmine::params::rails_version
  require rails
  require git
  user{'redmine':
    ensure => 'present',
    shell  => '/bin/nologin',
  }
}
