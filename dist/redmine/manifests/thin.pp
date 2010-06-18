define redmine::thin ($db, $db_user, $db_pw, $dir, $port='80') {
  include apache::params

  a2mod { [ 'proxy', 'proxy_balancer', 'proxy_http' ]: ensure => present, }

  package { 'thin':
    ensure => installed,
  }

  service { 'thin':
    ensure => running,
    enable => true,
    require => [ Package['thin'], File['/etc/thin/redmine.yml'] ],
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
    template => 'redmine/redmine-thin.conf.erb',
    require => Service['thin'],
  }

  file { "${dir}/${name}/config/environment.rb":
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Redmine::Instance[$name],
  }

  file { '/etc/thin/redmine.yml':
    content => template('redmine/redmine-thin.yml.erb'),
    require => Package['thin'],
  }
}
