#
# installs an instance of wordpress
#
define wordpress::instance( $auth_key, $secure_auth_key, $logged_in_key, $nonce_key, $dir='/var/www/', $port='80', $db_pw) {
  include wordpress
  $vhost_dir = "${dir}/${name}"
  file{[$dir, $vhost_dir]:
    ensure => directory,
  }
  mysql::db{$name:
    db_user => $name,
    db_pw => $db_pw,
  }
  apache::vhost{$name:
    port    => $port,
    docroot => $vhost_dir,
    webdir  => $vhost_dir,
  }
  #
  # Develop a wordpress versioning/staging strategy.
  #
}
