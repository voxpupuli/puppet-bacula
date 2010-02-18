# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# I think I need to change this to download the latest version from git
#
class redmine {

  require rails
  require redmine::mysql

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
  # configures the database for redmine
  file {[$base, $dir]:
    ensure => directory,
  }
  # download the module from git 
  Exec{
    logoutput => on_failure , 
    path => '/usr/bin:/bin'
  }
  exec {'download-redmine':
    command   => "wget ${url} -O ${tgz}",
    creates   => $tgz,
  }
  exec {'untar redmine':
    command => "tar -xvzf ${tgz}",
    cwd     => $dir,
    require => [ Exec['download-redmine'], File[$dir]],
    creates => $reddir,
    before   => Exec['session'],
  }
# this should probably be a file fragment for managing multi environments
  rails::db_config{$reddir:
    adapter  => 'mysql',
    username => $redmine_db_user,
    password => $redmine_db_pw,
    database => $redmine_db,
    socket   => $redmine_db_socket,
    require  => Exec['untar redmine'],
    before   => Exec['session'],
  }
#
# now, lets fire up this database
#

  exec{'session':
    #command     => 'echo $RAILS_ENV >> blah',
    command    => '/usr/bin/rake config/initializers/session_store.rb',
    environment => 'RAILS_ENV=production',
    cwd         => $reddir,
    creates     => "${reddir}/config/initializers/session_store.rb"
  }

  exec{'migrate':
    command => '/usr/bin/rake db:migrate',
    #command => 'echo $RAILS_ENV >> /tmp/blah',
    cwd     => $reddir,
    environment => 'RAILS_ENV=production',
    require => Exec['session'],
    creates => "${reddir}/db/schema.rb"
  }
#
# this is totally untested, and I need to set a limiting facter that determines when to 
# apply this resource
#
  if $redmine_default_data {
    exec{'default':
      command     => '/usr/bin/rake redmine:load_default_data',
      cwd         => $reddir,
      environment => 'RAILS_ENV=production',
      require     => Exec['migrate'],
    }
  }

  user{'redmine':
    ensure => 'present',
    shell  => '/bin/nologin',
  }

  file{
    [ "${reddir}/public", 
      "${reddir}/files", 
      "${reddir}/log", 
      "${reddir}/tmp", 
      "${reddir}/public/plugin_assets"
    ]:
    ensure  => directory,
    recurse => true,
    owner   => 'redmine',
    group   => 'redmine',
    mode    => '0755',
    require  => Exec['migrate'],
  }
  $redmine_port='3000'
  exec{'start-redmine':
    command => 'ruby script/server webrick -e production &',
    unless  => "netstat -ltn | grep ${redmine_port}",
    cwd     => $reddir,
    user    => 'redmine',
  }
# now lets configure fusion
#
#  include passenger


}
