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
# installs nagios server
class nagios::redhat::server inherits nagios::redhat {
	package { "nagios":
		notify     => Service["nagios"],
		require    => [ Class["yum"], Class["apache::ssl"], Class["mailx"] ],
	}
	# allow for NRPE communciation
	package { "nagios-plugins-nrpe":
		require    => [ Class["yum"], Package["nagios"], Package["nagios-plugins"] ],
	}
	# make sure our nagios.conf is installed 
	file { "/etc/httpd/conf.d/nagios.conf":
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'root',
		mode       => '0444',
		source     => "puppet:///nagios/nagios.conf",
		require    => Package["nagios"],
	}
	# monitor htpasswd.users
	file { "/etc/nagios/htpasswd.users":
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0640',
		require    => Package["nagios"],
	}
	# make sure nagios is setup to run
	service { "nagios":
		name       => "nagios",
		ensure     => running,
		enable     => true,
		hasrestart => true,
	}
}
