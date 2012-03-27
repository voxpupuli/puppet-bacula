#
# installs an instance of wordpress
#
define wordpress::instance(
    $auth_key        = 'nDF9aQ0XwHn8VSEdEsG7niUN5AbNUEdiKyGrKcy8Y2QXooSDLPFEKKX5885Zbku',
    $secure_auth_key = 'Py7qoZiAY4P7kYERSMKmX7bnN1g7aO6gprRhcFmH4bHuv3FkLUcCS8NJvGDv0xH',
    $logged_in_key   = 'eW9kxY7lw2dgHf68NADWE34awypYnoJbSW84icE6319t5DkMFtZ9wIY1ti34ylD',
    $nonce_key       = '3vQabQDY67MIr3sZsPtYbsQehdNSFyEead3X825JwBzRhEL1clGOQ4eJCKdtst0',
    $dir             = '/var/www',
    $port            = '80',
    $db_user         = '',
    $db_pw,
    $template,
    $priority        = '10',
    $backup          = true,
    $seturl          = false,
    $site_alias      = ''
  ) {

  include wordpress
  $dbname = regsubst($name, '\.|\-', '', 'G')
  if $db_user {
    $dbuser = $db_user
  } else {
    $dbuser = $dbname
  }
  $vhost_dir = "${dir}/${name}"

  if ! defined(File[$dir]) { file { $dir: ensure => directory; } }
#
#  File[$vhost_dir] -> Exec["wp_install_$vhost_dir"] -> File["$vhost_dir/wp-config.php"]
#  Exec["wp_unzip"] -> Exec["wp_install_$vhost_dir"]
#
  file { $vhost_dir: ensure => directory; }
#
#  exec {
#    "wp_install_$vhost_dir":
#      cwd => $vhost_dir,
#      command => "/usr/bin/rsync -a /usr/local/src/wordpress/ $vhost_dir/",
#      creates => "$vhost_dir/wp-admin";
#  }

  exec {
    'install_wordpress':
      command => "/usr/bin/rsync -a /usr/local/src/wordpress/ $vhost_dir/ && /usr/bin/touch ${vhost_dir}/../.${dbname}_installed",
      creates => "${vhost_dir}/../.${dbname}_installed",
  }

  file {
    "$vhost_dir/wp-config.php":
      mode    => 644,
      content => template("wordpress/wp-config.php.erb");
  }

  mysql::db{
    $dbname:
      db_user => $dbuser,
      db_pw   => $db_pw,
  }

  apache::vhost{
    $name:
      port     => $port,
      serveraliases => $site_alias ? {
        ''      => undef,
        default => $site_alias,
      },
      docroot  => $vhost_dir,
      template => $template,
      priority => $priority,
  }

  # database backups have been moved to mysql::db
  #if $backup == true {
  #  bacula::mysql { $dbname: }
  #}

  # Develop a wordpress versioning/staging strategy.
  #
}
