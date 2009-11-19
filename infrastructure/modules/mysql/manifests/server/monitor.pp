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
# install mysql user to allow remote monitoring
class mysql::server::monitor {
    case $mysql_monitor_username {
		'': { fail("You need to define a mysql monitor username! Please set \$mysql_monitor_username in your site.pp or node config") }
	}
    case $mysql_monitor_password {
		'': { fail("You need to define a mysql monitor password! Please set \$mysql_monitor_password in your site.pp or node config") }
	}
    case $mysql_monitor_hostname {
		'': { fail("You need to define a mysql monitor hostname! Please set \$mysql_monitor_hostname in your site.pp or node config") }
	}
	mysql_user{ "${mysql_monitor_username}@${mysql_monitor_hostname}":
		password_hash => mysql_password($mysql_monitor_password),
		ensure        => present,
		require       => Service['mysqld'],
	}
	mysql_grant { "${mysql_monitor_username}@${mysql_monitor_hostname}":
		privileges    => [ 'process_priv', 'super_priv' ],
		require       => Mysql_user["${mysql_monitor_username}@${mysql_monitor_hostname}"], 
		require       => Service['mysqld'],
	}
}
