# Define: nginx::server::vhost
#
#   nginx vhost. For serving web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::unicorn(
  $port,
  #$dest,
  $unicorn_socket,
  $priority   = '10',
  $template   = 'nginx/vhost-unicorn.conf.erb',
  $servername = '',
  $path       = '',
  $auth       = '',
  $magic      = ''
  ) {

  include nginx

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $path == '' {
    $rootpath = "/var/www/$srvname"
  } else {
    $rootpath = $path
  }


  file {
    "${nginx::params::vdir}/${priority}-${name}":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['nginx'],
      notify  => Service['nginx'],
  }

  # liberally borrowed from apache module.
  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
    @firewall {
      "0100-INPUT ACCEPT $port":
        jump  => 'ACCEPT',
        dport => "$port",
        proto => 'tcp'
    }
  }

}
# EOF
