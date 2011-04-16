define apache::vhost::proxy (
    $port,
    $dest,
    $priority = '10',
    $template = "apache/vhost-proxy.conf.erb",
    $servername    = '',
    $serveraliases = '',
    $ssl = false
    ) {

  include apache

  $srvname = $name

  if $ssl == true {
    include apache::ssl
  }

  file {"${apache::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
