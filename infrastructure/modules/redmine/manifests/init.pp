# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#


#
# I think I need to change this to download the latest version from git
#
class redmine {

  # redmine_version
  # redmine_git_url
  # 

  $version = '0.8.7'
  $verstr  = "redmine-${version}"
  $url     = "http://github.com/edavis10/redmine/tarball/${version}"
  $srcdir  = '/usr/local/src'
  $base    = '/usr/local/redmine'
  $tgz     = "${srcdir}/${verstr}.tgz"
  $dir     = "${base}/${verstr}"
  $reddir  = "${dir}/edavis10-redmine-78db298"
  # this installed rails, and mysql, as well as ruby dev tools
  # installs and configures rails for redmine
  require rails
  # configures the database for redmine
  include redmine::mysql
  file {[$base, $dir]:
    ensure => directory,
  }
  # download the module from git 
  Exec{logoutput => on_failure , path => '/usr/bin:/bin'}
  exec {'download-redmine':
    command   => "wget ${url} -O ${tgz}",
    creates   => $tgz,
  }
  exec {'untar redmine':
    command => "tar -xvzf ${tgz}",
    cwd     => $dir,
    require => [ Exec['download-redmine'], File[$dir]],
    creates => $reddir,
  }
# this should probably be a file fragment for managing multi environments
  rails::db_config{$reddir:
    adapter  => 'mysql',
    username => $redmine_db_user,
    password => $redmine_db_pw,
    database => $redmine_db,
    require  => Exec['untar redmine'],
  }
#
# now, lets fire up this database
#

#  exec{'rake db:migrate':
#    path => '/usr/bin',
#    require => [Class['rails'], Class['redmine::mysql']],
#  }

#
# now lets configure fusion
#
#  include passenger


}
