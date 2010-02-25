# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# I think I need to change this to download the latest version from git
#
#

define redmine::instance ($db_user, $db_pw, $db, $db_socket, $user, $group, $dir) {
  include redmine  
  $dir     = $redmine::params::dir 
  $version = $redmine::params::version
  $source  = $redmine::params::source
  # download the module from git 
  vcsrepo{"${dir}/${name}":
    source  => $source,
    revision => $version, 
  }
  #
  # this should probably be a file fragment for managing multi environments
  #
  redmine::mysql { "redmine_${name}":
    db_user => $db_user,
    db_pw => $db_pw,
    db => $db,
    db_socket => $db_socket,
    require => Vcsrepo["${dir}/${name}"],
    before => Exec['session'],
  }
  #
  # now, lets fire up this database
  #
  Exec{
    logoutput => on_failure , 
    path      => '/usr/bin:/bin'
  }
  exec{'session':
    command => '/usr/bin/rake config/initializers/session_store.rb',
    environment => 'RAILS_ENV=production',
    cwd         => "${dir}/${name}",
    require     => [Class['rails'], Class['redmine::mysql']],
    creates     => "${dir}/${name}/config/initializers/session_store.rb"
  }

  exec{'migrate':
    command => '/usr/bin/rake db:migrate',
    cwd     => "${dir}/${name}",
    environment => 'RAILS_ENV=production',
    require => Exec['session'],
    creates => "${dir}/${name}/db/schema.rb"
  }
  #
  # this is totally untested, and I need to set a limiting facter that determines when to 
  # apply this resource
  #
  if $redmine_default_data {
    exec{'default':
      command     => '/usr/bin/rake redmine:load_default_data',
      cwd         => "${dir}/${name}",
      environment => 'RAILS_ENV=production',
      require     => Exec['migrate'],
    }
  }
  file{ [ "${dir}/${name}/public", "${dir}/${name}/files", "${dir}/${name}/log", "${dir}/${name}/tmp", "${dir}/${name}/public/plugin_assets" ]:
    ensure => directory,
    recurse => true,
    owner => $user,
    group => $group,
    mode => '0755',
    require => Exec['migrate'],
  }
}
