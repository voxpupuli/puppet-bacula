define unicorn::app (
    $approot,
    $config     ='config/unicorn.config.rb',
    $initscript = "unicorn/initscript_newer.erb" #default template location
  ) {

  # get the common stuff, like the unicon package(s)
  include unicorn

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
      content => template("${initscript}");
  }

}

