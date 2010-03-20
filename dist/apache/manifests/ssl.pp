class apache::ssl {
  include apache

  
  case $operatingsystem {
     "centos": {
        package { $apache::params::ssl_package:
           require => Package['httpd'],
        }
     }
     "ubuntu": {
        exec { "a2enmod ssl": 
           path => "/usr/bin:/usr/sbin:/bin",
           creates => "/etc/apache2/mods-enabled/ssl.load",
        }
        exec { "a2enmod headers":
           path => "/usr/bin:/usr/sbin:/bin",
           creates => "/etc/apache2/mods-enabled/headers.load",
        }
     }
  }
}
