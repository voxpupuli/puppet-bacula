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
# installs mysql 
class mysql::server {
  # set the mysql root password
  if(! $mysql_root_pw) {
    fail('$mysql_root_pw must be set for class mysql::server')
  }

  include mysql::params

  $mysql_service_name = $mysql::params::mysql_service_name

  package{
    'mysql-server':
      name   => 'mysql-server',
      ensure => installed,
      notify => Service['mysqld'],
  }
  service { 
    'mysqld':
      name   => $mysql_service_name,
      ensure => running,
      enable => true,
  }

  # this kind of sucks, that I have to specify a difference resource for restart.
  # the reason is that I need the service to be started before mods to the config
  # file which can cause a refresh
  service{
    'mysqld-restart':
      restart => "/usr/sbin/service ${mysql_service_name} restart"
  }

  File {
    owner   => 'mysql',
    group   => 'mysql',
    require => Package['mysql-server'],
  }

  # use the previous password for the case where its not configured in /root/.my.cnf
  case $mysql_old_pw {
    '': {$old_pw=''}
    default: {$old_pw="-p${mysql_old_pw}"}
  }

  exec{ 'set_mysql_rootpw':
    command   => "mysqladmin -u root ${old_pw} password ${mysql_root_pw}",
    #logoutput => on_failure,
    logoutput => true,
    unless    => "mysqladmin -u root -p${mysql_root_pw} status > /dev/null",
    path      => '/usr/local/sbin:/usr/bin',
    require   => [Package['mysql-server'], Service['mysqld']],
    before    => File['/root/.my.cnf'],
    notify    => Service['mysqld-restart'],
  }

  file{['/root/.my.cnf', '/etc/my.cnf']:
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template('mysql/my.cnf.erb'),
    notify  => Service['mysqld-restart'],
  }

}

