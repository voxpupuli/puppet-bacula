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
# installs nagios 
class nagios::debian {
	package { "nagios-plugins-standard":
	}
	package { "nagios-plugins-basic":
		require    => Package["nagios-plugins-standard"],
	}
	package { "nagios-plugins-extra":
		require    => Package["nagios-plugins-standard"],
	}
	package { "nagios-plugins":
		require    => Package["nagios-plugins-standard"],
	}
    # track check_iptables
	file { "check_iptables":
		name       => "/usr/lib/nagios/plugins/check_iptables",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'root',
		mode       => '0555',
		source     => "puppet:///nagios/check_iptables.sh",
		require    => Package["nagios-plugins-standard"],
	}
	# track check_clamav
	file { "check_clamav":
		name       => "/usr/lib/nagios/plugins/check_clamav",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'root',
		mode       => '0555',
		source     => "puppet:///nagios/check_clamav.sh",
		require    => Package["nagios-plugins-standard"],
	}
	# track check_memory
	file { "check_memory":
		name       => "/usr/lib/nagios/plugins/check_memory",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'root',
		mode       => '0555',
		source     => "puppet:///nagios/check_memory.pl",
		require    => Package["nagios-plugins-standard"],
	}
	# event handlers to restart-daemon
	file { "restart-daemon":
		name       => "/usr/lib/nagios/plugins/restart-daemon",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'root',
		mode       => '0555',
		source     => "puppet:///nagios/restart-daemon.debian.sh",
		require    => Package["nagios-plugins-standard"],
	}
}
