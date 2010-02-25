#
# installs an instance of wordpress
#
define wordpress::instance(
    $db, $db_user, $db_pw, 
    $auth_key, $secure_auth_key, $logged_in_key, $nonce_key, 
    $dir='/opt/wordpress', $port='80') {
  include wordpress
  include wordpress::params
  require svn
  Exec{path => '/usr/bin:/bin'}
  $vhost_dir = "${dir}/${name}"
  $app_dir = "${vhost_dir}/${wordpress::params::version}"
  file{[$dir, $vhost_dir]:
    ensure => directory,
  }

  exec{"${name}-download":
    command => "svn co ${wordpress::params::source}", 
    creates => $app_dir,
    cwd => $vhost_dir,
  }
  # this database name must be unique
  mysql::db{$db:
    db_user => $db_user,
    db_pw => $db_pw,
    
  }
  file{"${app_dir}/wp-config.php":
    content => template('wordpress/wp-config.php.erb'),
  }
  apache::vhost{$name:
    port    => $port,
    docroot => $app_dir,
    webdir  => $app_dir,
  }
}
