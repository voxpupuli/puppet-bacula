class redmine::passenger {
  include redmine
  include passenger
  include redmine::params
  apache::vhost{'puppet-ubuntu':
    port    => '80',
    docroot => "${redmine::params::reddir}/public/",
    webdir  => "${redmine::params::reddir}/",
  }
   #require  => Class['redmine'],
}
