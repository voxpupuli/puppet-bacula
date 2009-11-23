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
# installs nagios::server
class nagios::server {
	case $operatingsystem {
		centos, redhat: { include nagios::redhat::server }
		debian, ubuntu: { include nagios::debian::server }
		default: { fail("nagios::server is not defined for this operating system.") }
	}

	# install commands.cfg
	file { "/etc/nagios/commands.cfg":
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0440',
		source     => "puppet:///nagios/commands.cfg",
		require    => Package["nagios"],
		notify     => Service["nagios"],
	}
	# install event_handlers.cfg
	file { "/etc/nagios/event_handlers.cfg":
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0440',
		source     => "puppet:///nagios/event_handlers.cfg",
		require    => Package["nagios"],
		notify     => Service["nagios"],
	}
	# install timeperiods.cfg
	file { "/etc/nagios/timeperiods.cfg":
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0440',
		source     => "puppet:///nagios/timeperiods.cfg",
		require    => Package["nagios"],
		notify     => Service["nagios"],
	}
	# make sure resource.cfg has proper perms
	file { "/etc/nagios/private/resource.cfg":
		checksum   => md5,
		ensure     => present,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0640',
		require    => Package["nagios"],
		notify     => Service["nagios"],
	}
}
