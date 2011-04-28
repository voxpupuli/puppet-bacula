#
# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#

define redmine::instance (
    $db,
    $db_user,
    $db_pw,
    $user,
    $group,
    $dir,
    $backup = true
    ) {

  require redmine
  $version = $redmine::params::version
  $source  = $redmine::params::source

  vcsrepo{
    "${dir}/${name}":
      source   => $source,
      revision => $version,
      #require => File[$dir],
      #path => $dir,
  }

  # this should probably be a file fragment for managing multi environments
  #
  if(defined(Database[$db])) {
    fail("redmine::instance declared with duplicate database ${db}")
  }

  rails::mysql::db {$db:
    db_user => $db_user,
    db_pw   => $db_pw,
    dir     => "${dir}/${name}",
    require => Vcsrepo["${dir}/${name}"],
    before  => Exec["${name}-session"],
  }

  # Let's make sure the database is backed up
  #
  if $backup == true {
    bacula::mysql { $db: }
  }

  # now, lets fire up this database
  #
  Exec{ logoutput => on_failure, path => '/usr/bin:/bin'}
  exec{"${name}-session":
    command     => '/usr/bin/rake config/initializers/session_store.rb',
    environment => 'RAILS_ENV=production',
    cwd         => "${dir}/${name}",
    require     => Class['rails'],
    creates     => "${dir}/${name}/config/initializers/session_store.rb"
  }
  exec{"${name}-migrate":
    command     => '/usr/bin/rake db:migrate',
    cwd         => "${dir}/${name}",
    environment => 'RAILS_ENV=production',
    require     => Exec["${name}-session"],
    creates     => "${dir}/${name}/db/schema.rb"
  }

  if $redmine_default_data {
    exec{"${name}-default":
      command     => '/usr/bin/rake redmine:load_default_data',
      cwd         => "${dir}/${name}",
      environment => 'RAILS_ENV=production',
      require     => Exec["${name}-migrate"],
    }
  }

  file{
    [ "${dir}/${name}/public", "${dir}/${name}/public/plugin_assets" ]:
      ensure  => directory,
      #recurse => true,
      owner   => $user,
      group   => $group,
      mode    => '0755',
      require => Exec["${name}-migrate"],
  }

  file{
    "${dir}/${name}/log":
      ensure  => directory,
      #recurse => true,
      owner   => $user,
      group   => $group,
      mode    => '0666',
      require => Exec["${name}-migrate"],
  }

  file{
    [ "${dir}/${name}/files", "${dir}/${name}/tmp" ]:
      ensure  => directory,
      #recurse => true,
      owner   => $user,
      group   => $group,
      mode    => '0755',
      require => Exec["${name}-migrate"],
  }


  file {
    "/usr/local/bin/redmine_permission_keeper.sh":
      owner => root,
      group => root,
      mode  => 0750,
      content => template("modules/redmine/permission_keeper.sh");
  }

  cron {
    "Redmine: permission_keeper.sh":
      command => "/usr/local/bin/redmine_permission_keeper.sh",
      user    => root,
      minute  => "*/15",
      require => File["/usr/local/bin/redmine_permission_keeper.sh"];
    # recursion file type makes for huge reports + checksumming when we just care about perms
    "redmine_files_and_tmp_permissions":
      command => "/usr/bin/find ${dir}/${name}/files ${dir}/${name}/tmp -exec chown $user:$group {} \; ; /usr/bin/find ${dir}/${name}/files ${dir}/${name}/tmp -exec chmod 755 {} \;",
      user    => root,
      ensure  => absent,
      minute  => "*/15";
    # recursion file type makes for huge reports
    "redmine_public_and_log_permissions":
      command => "/usr/bin/find ${dir}/${name}/public ${dir}/${name}/log -exec chown $user:$group {} \; ; /usr/bin/find ${dir}/${name}/public ${dir}/${name}/log -exec chmod 755 {} \;",
      user    => root,
      ensure  => absent,
      minute  => "*/15";
  }

}
