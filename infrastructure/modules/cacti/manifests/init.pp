# Copyright 2009 Larry Ludwig (larrylud@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License"); you 
# may not use this file except in compliance with the License. You 
# may obtain a copy of the License at 
#
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express 
# or implied. See the License for the specific language governing 
# permissions and limitations under the License. 
#
# installs cacti 
class cacti {
  # check for required parameters
  if(!$cacti_password) {
    fail('variable $cacti_password must be set for class cacti')
  }
  # class/resource dependencies
  include php, mysql::server, apache
  require php, mysql::server

  package {['cacti', 'cacti-docs', 'cacti-spine']:}
	
  File{
    mode    => 0444,
    require => Package['cacti'], 
  }

  file { "/etc/httpd/conf.d/cacti.conf":
    ensure     => present,
    source     => "puppet:///cacti/cacti.conf",
    # this should do a reload and not a restart
    notify     => Service["apache"],
  }

  file { "/var/www/cacti/include/config.php":
    content   => template("cacti/config.php.erb"),
  }
  
  file { "/etc/spine.conf":
    owner     => 'cacti',
    group     => 'cacti',
    mode      => '0400',
    content   => template("cacti/spine.conf.erb"),
  }

  mysql_database { "cacti":
    ensure     => present,
    require    => Package["cacti"],
    notify     => Exec["create-mysql-cacti"],
  }
  
  mysql_user{ "cacti@localhost":
    password_hash => mysql_password($cacti_password),
    ensure        => present,
    require       => Mysql_database["cacti"],
  }
  
  exec { "create-mysql-cacti":
    command     => '/usr/bin/mysql cacti < /var/www/cacti/cacti.sql',	
    logoutput   => on_failure,
    refreshonly => true,	
    require     => Package["cacti"],
  }
}
