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
class mysql::redhat::server inherits mysql::redhat {
	# install mysql rpms
	package { 'MySQL-server-community':
		notify    => Service['mysqld'],
		before    => Class['mysql::server::base'],
	}
	# make sure mysql is setup to run
	service { 'mysqld':
		name      => 'mysql',
		ensure    => running,
		enable    => true,
		subscribe => File['/etc/my.cnf'],
	}
}
