class redmine::passenger {
  require redmine
  include passenger
  include redmine::params
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
