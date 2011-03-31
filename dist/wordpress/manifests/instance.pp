#
# installs an instance of wordpress
#
define wordpress::instance( 
    $auth_key, 
    $secure_auth_key, 
    $logged_in_key, 
    $nonce_key, 
    $dir='/var/www/', 
    $port='80', 
    $db_pw, 
    $template, 
    $priority = '00',
    $backup = true,
    $development = false
  ) {

  include wordpress
  $dbname = regsubst($name, '\.', '', 'G')
  $db_user = $dbname
  $vhost_dir = "${dir}/${name}"

  file{[$dir, $vhost_dir]:
    ensure => directory,
  }

  file { 
    "$vhost_dir/wp-config.php":
      mode => 644,
      content => template("wordpress/wp-config.php.erb");
  }

  mysql::db{$dbname:
    db_user => $dbname,
    db_pw => $db_pw,
  }

  apache::vhost{$name:
    port    => $port,
    docroot => $vhost_dir,
    template => $template,
    priority => $priority,
  }

  if $backup == true {
    bacula::mysql { $dbname: }
  }
  
  # Develop a wordpress versioning/staging strategy.
  #
}
