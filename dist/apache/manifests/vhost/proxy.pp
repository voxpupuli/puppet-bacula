define apache::vhost::proxy (
    $port,
    $dest,
    $priority = '10',
    $template = "apache/vhost-proxy.conf.erb"
    ) {
  include apache

  $srvname = $name

  file {"${apache::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
