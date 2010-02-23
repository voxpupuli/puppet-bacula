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
 
  $redmine_dir     = $redmine::params::redmine_dir 
  $redmine_version = $redmine::params::redmine_version
  $redmine_source  = $redmine::params::redmine_source
  # download the module from git 
  vcsrepo{$redmine_dir:
    source  => $redmine_source,
    revision => $redmine_version, 
  }
# this should probably be a file fragment for managing multi environments
  rails::db_config{$redmine_dir:
    adapter  => 'mysql',
    username => $redmine_db_user,
    password => $redmine_db_pw,
    database => $redmine_db,
    socket   => $redmine_db_socket,
    require  => Vcsrepo[$redmine_dir],
    before   => Exec['session'],
  }
#
# now, lets fire up this database
#

  Exec{
    logoutput => on_failure , 
    path      => '/usr/bin:/bin'
  }

  exec{'session':
    #command     => 'echo $RAILS_ENV >> blah',
    command    => '/usr/bin/rake config/initializers/session_store.rb',
    environment => 'RAILS_ENV=production',
    cwd         => $redmine_dir,
    require     => [Class['rails'], Class['redmine::mysql']],
    creates     => "${redmine_dir}/config/initializers/session_store.rb"
  }

  exec{'migrate':
    command => '/usr/bin/rake db:migrate',
    #command => 'echo $RAILS_ENV >> /tmp/blah',
    cwd     => $redmine_dir,
    environment => 'RAILS_ENV=production',
    require => Exec['session'],
    creates => "${redmine_dir}/db/schema.rb"
  }
#
# this is totally untested, and I need to set a limiting facter that determines when to 
# apply this resource
#
  if $redmine_default_data {
    exec{'default':
      command     => '/usr/bin/rake redmine:load_default_data',
      cwd         => $redmine_dir,
      environment => 'RAILS_ENV=production',
      require     => Exec['migrate'],
    }
  }

  user{'redmine':
    ensure => 'present',
    shell  => '/bin/nologin',
  }

  file{
    [ "${redmine_dir}/public", 
      "${redmine_dir}/files", 
      "${redmine_dir}/log", 
      "${redmine_dir}/tmp", 
      "${redmine_dir}/public/plugin_assets"
    ]:
    ensure  => directory,
#    recurse => true,
    owner   => 'redmine',
    group   => 'redmine',
    mode    => '0755',
    require  => Exec['migrate'],
  }
}
