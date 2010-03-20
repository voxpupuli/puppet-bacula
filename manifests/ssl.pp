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
        }
        exec { "a2enmod headers":
           path => "/usr/bin:/usr/sbin:/bin",
        }
     }
  }
}
