define redmine::passenger ( er, $db_pw, $db, $db_socket, $user, $group, $dir, $port, ) {

  include ::passenger
  include redmine::params
  require redmine
  $dir = $redmine::params::dir
  apache::vhost{'puppet-ubuntu':
    port    => '80',
    docroot => "${dir}/public/",
    webdir  => "${dir}/",
  }
  file{"${dir}/config/environment.rb":
    owner   => 'www-data',
    group   => 'www-data',
    require => Class['redmine'],
  }
}
