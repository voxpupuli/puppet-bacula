define apache::port (
    $port,
    $vhost_name = '*'
  ) {
  include apache
  include concat::setup

  case $operatingsystem {
    debian,
    ubuntu:  {
      if ! defined(Concat::Fragment["apache_port_${port}"]) { #only create it if its not already there
        concat::fragment { "apache_port_${port}":
          target  => "/etc/apache2/ports.conf",
          content => inline_template("Listen <%= port %>\nNameVirtualHost <%= vhost_name %>:<%= port %>\n")
        }
      }
    }
    default: {
      err("apache::port does not support Operating System ${operatingsystem}")
    }
  }

}
