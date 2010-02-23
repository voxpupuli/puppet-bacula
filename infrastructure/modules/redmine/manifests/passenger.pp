class redmine::passenger {
  include redmine
  include passenger
  include redmine::params
  $redmine_dir = $redmine::params::redmine_dir
  apache::vhost{'puppet-ubuntu':
    port    => '80',
    docroot => "${redmine_dir}/public/",
    webdir  => "${redmine_dir}/",
  }
   #require  => Class['redmine'],
}
