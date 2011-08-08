define unicorn::app (
    $approot,
    $config='config/unicorn.config.rb'
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
      content => tempalte("unicorn/initscript.erb");
  }

}

