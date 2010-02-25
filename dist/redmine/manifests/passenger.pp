define redmine::passenger ($db, $db_user, $db_pw, $dir, $port) {
  include apache::params
  include ::passenger
  require redmine
  redmine::instance{$name:
    db => $db,
    db_user => $db_user,
    db_pw => $db_pw, 
    user => $apache::params::user, 
    group => $apache::params::group, 
    dir => $dir,
  }
  apache::vhost{$name:
    port    => $port,
    docroot => "${dir}/${name}/public/",
    webdir  => "${dir}/${name}/",
  }
  file{"${dir}/${name}/config/environment.rb":
    owner   => $apache::params::user,
    group   => $apache::params::group,
  }
}
