# ensure apache is installed
class apache {
<<<<<<< HEAD:dist/apache/manifests/init.pp
  package { ["apache2"]: ensure => present }
  service { "apache2":
    ensure => running,
    enable => true,
=======
  $apache_name = $operatingsystem? {
    'ubuntu'  => 'apache2',
    default => 'httpd',
  }
  package{'httpd': 
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
  service { 'httpd':
    name      => $apache_name,
    ensure    => running,
    enable    => true,
#    subscribe => File["/etc/sysconfig/httpd"],
    subscribe => Package['httpd'],
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/apache/manifests/init.pp
  }
}
