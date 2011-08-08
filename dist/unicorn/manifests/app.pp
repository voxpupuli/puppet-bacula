define unicorn::app (
    $approot,
    $config='config/unicorn.config.rb"
  ) {

  # get the common stuff, like package(s)
  include unicorn

  service {
    "unicorn_$name":
      ensure  => running,
      enable  => true,
      require => [
        Package['unicorn'],
        File["/etc/init.d/unicorn_$name"],
      ]
  }


}
