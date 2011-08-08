define unicorn::app (
    $approot,
    $config='config/unicorn.config.rb',
    $initscript = "unicorn/initscript.erb" #default template location
  ) {

  # get the common stuff, like package(s)
  include unicorn

  service {
    "unicorn_$name":
      ensure  => running,
      enable  => true,
      require => File["/etc/init.d/unicorn_$name"],
  }

  file {
    "/etc/init.d/unicorn_$name":
      owner   => root,
      group   => root,
      mode    => 755,
      content => template("$initscript");
  }

}

