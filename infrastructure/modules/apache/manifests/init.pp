# ensure apache is installed
class apache {
  $apache_name = $operatingsystem? {
    'ubuntu'  => 'apache2',
    default => 'httpd',
  }
  package{"httpd": 
    name   => $apache_name,
    ensure => present,
  }
# I dont know where the default arguments go for Ubuntu
#  file{ "/etc/sysconfig/httpd":
#    ensure  => present,
#    owner   => "root",
#    group   => "root",
#    mode    => "644",
#    source  => "puppet:///modules/apache/httpd",
#    require => Package["httpd"],
#  }
  service { "httpd":
    name      => $apache_name,
    ensure    => running,
    enable    => true,
#    subscribe => File["/etc/sysconfig/httpd"],
    subscribe => Package['httpd'],
  }
}
