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
class mysql::server::base {
    file{ '/var/lib/mysql/data':
		ensure    => directory,
		owner     => 'mysql',
		group     => 'mysql',
		mode      => '0755',
		before    => File['/usr/local/sbin/setmysqlpass.sh'],
	}
	file{ '/var/lib/mysql/data/ibdata1':
		ensure    => file,
		owner     => 'mysql',
		group     => 'mysql',
		mode      => '0660',
		before    => File['/usr/local/sbin/setmysqlpass.sh'],
	}
	file{ '/usr/local/sbin/setmysqlpass.sh':
		owner     => 'root',
		group     => 'root',
		mode      => '0500',
		source    => 'puppet:///mysql/setmysqlpass.sh',
	}
	exec{ 'set_mysql_rootpw':
		command   => "/usr/local/sbin/setmysqlpass.sh $mysql_rootpw",
		unless    => 'mysqladmin -uroot status > /dev/null',
		require   => File['/usr/local/sbin/setmysqlpass.sh'],
		before    => File['/root/.my.cnf'],
	}
	# store the password for root
	file { '/root/.my.cnf':
		owner     => 'root',
		group     => 'root',
		mode      => '0400',
		content   => template('mysql/my.cnf.erb'),
		notify    => Service['mysqld'],
	}
}
