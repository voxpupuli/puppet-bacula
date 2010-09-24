define redmine::unicorn ($db, $db_user, $db_pw, $dir, $port='80') {
  include apache::params

  a2mod { [ 'proxy', 'proxy_balancer', 'proxy_http' ]: ensure => present, }

  package { 'unicorn':
    ensure => installed,
    provider => gem,
  }

  service { 'unicorn':
    ensure => running,
    enable => true,
    require => Package['unicorn'],
  }

  redmine::instance { $name:
    db => $db,
    db_user => $db_user,
    db_pw => $db_pw, 
    user => $apache::params::user, 
    group => $apache::params::group, 
    dir => $dir,
  }

  apache::vhost { $name:
    port     => $port,
    priority => '30',
    docroot  => "${dir}/${name}/public/",
    template => 'redmine/redmine-unicorn.conf.erb',
    require => Service['unicorn'],
  }

  file { "${dir}/${name}/config/environment.rb":
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Redmine::Instance[$name],
  }
  file { "${dir}/${name}/config/unicorn.config.rb":
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Redmine::Instance[$name],
    source  => "puppet:///modules/redmine/unicorn.config.rb";
  }

}
