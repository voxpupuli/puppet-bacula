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
	case $mysql_rootpw {
		'': { fail("You need to define a mysql root password! Please set \$mysql_rootpw in your site.pp or host config") }
	}
    case $operatingsystem {
		centos, redhat: { include mysql::redhat::server }
		default: { fail("${title} is not defined for operating system ${operatingsystem}.") }
	}

	# setup the base items
	include mysql::server::base
	include mysql::server::mysqltuner

	# install monitoring username if nrpe or snmp is enabled
	if tagged(nrpe) {
		include mysql::server::monitor
	}
	if tagged(cacti) {
		include mysql::server::monitor
	}
}
