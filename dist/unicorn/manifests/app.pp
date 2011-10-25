define unicorn::app (
    $approot,
    $unicorn_pidfile,
    $unicorn_socket,
    $rack_file,
    $config_template          = 'unicorn/config_unicorn.config.rb.erb',
    $initscript               = "unicorn/initscript_newer.erb", #default template location
    $unicorn_backlog          = '2048',
    $unicorn_worker_processes = '4',
    $unicorn_user             = '',
    $unicorn_group            = '',
    $config_file              = ''
  ) {

  # get the common stuff, like the unicon package(s)
  include unicorn

  # If we have been given a config path, use it, if not, make one up.
  if $config_file == '' {
    $config = "${approot}/config/unicorn.config.rb"
  } else {
    $config = $config_file
  }

  service {
    "unicorn_${name}":
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      restart    => "/etc/init.d/unicorn_${name} reload",
      require    => File["/etc/init.d/unicorn_${name}"],
  }

  file {
    "/etc/init.d/unicorn_${name}":
        owner   => root,
        group   => root,
        mode    => 755,
        content => template("${initscript}"),
        notify  => Service["unicorn_${name}"];
    $config:
        owner   => root,
        group   => root,
        mode    => 644,
        content => template( $config_template ),
        notify  => Service["unicorn_${name}"];
    "${approot}/config.ru":
        owner  => root,
        group  => root,
        mode   => 644,
        source => $rack_file,
        notify  => Service["unicorn_${name}"],
  }

}

