define redmine::unicorn (
    $db, 
    $db_user, 
    $db_pw, 
    $dir, 
    $port='80', 
    $backup='true',
    $version = 'UNSET'
    ) {
  include apache::params

	# more modules: ssl

  a2mod { [ 'proxy', 'proxy_balancer', 'proxy_http' ]: ensure => present, }

  $unicorn_packages = [ 'libmysql-ruby', 'unicorn', 'i18n' ]

  package {
    "libmysql-ruby": ensure => installed;
    'unicorn':       ensure => installed, provider => gem;
    'i18n':          ensure => '0.4.2',   provider => gem;
    # 'rack':          ensure => '1.1.0',   provider => gem;
    # uncomment the above ONCE we migrate redmine past 1.1.x
  }

  service { 
    'unicorn':
      ensure  => running,
      enable  => true,
      require => [
        Package['unicorn'],
        File["/etc/init.d/unicorn","${dir}/${name}/config/unicorn.config.rb"]],
  }

  redmine::instance { 
    $name:
      db      => $db,
      db_user => $db_user,
      db_pw   => $db_pw, 
      user    => $apache::params::user, 
      group   => $apache::params::group, 
      dir     => $dir,
      backup  => $backup,
      version => $version,
  }

  apache::vhost { $name:
    servername => $name,
    port       => $port,
    priority   => '30',
    ssl        => false,
    docroot    => "${dir}/${name}/public/",
    template   => 'redmine/redmine-unicorn.conf.erb',
    require    => Service['unicorn'],
  }

  apache::vhost { "${name}_ssl":
    servername => $name,
    port       => 443,
    priority   => '31',
    ssl        => true,
    docroot    => "${dir}/${name}/public/",
    template   => 'redmine/redmine-unicorn.conf.erb',
    require    => Service['unicorn'],
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
    content => template("redmine/unicorn.config.rb.erb");
  }

  file { "/etc/init.d/unicorn":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("redmine/unicorn.initscript.erb");
  }

  file { "/usr/bin/unicorn_rails":
    ensure => symlink,
    target => "/var/lib/gems/1.8/bin/unicorn_rails";
  }

}

