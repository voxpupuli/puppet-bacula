# ensure apache is installed
class apache {
  include apache::params

  package{'httpd': 
    name   => $apache::params::apache_name,
    ensure => present,
  }
  service { 'httpd':
    name      => $apache::params::apache_name,
    ensure    => running,
    enable    => true,
    subscribe => Package['httpd'],
  }
}
