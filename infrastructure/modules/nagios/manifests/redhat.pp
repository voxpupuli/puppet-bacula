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
class nagios::redhat {
	package { "nagios-plugins":
		require    => Class["yum"],
	}
	package { "nagios-moreplugs":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	# allow for restarting of services via eventhandlers
	package { "nagios-eventhandlers":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	package { "nagios-plugins-filerc":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	# Empowering Media's TCP port monitoring
	package { "nagios-plugins-ports":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	# Empowering Media's TCP rouge process monitoring
	package { "nagios-plugins-rogue":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	package { "perl-Nagios-Plugin":
		require    => [ Class["yum"], Package["nagios-plugins"] ],
	}
	package { "perl-Config-Tiny":
		require    => Class["yum"],
	}
	package { "nagios-of-plugins":
		require    => [ Package["perl-Config-Tiny"], Package["perl-Nagios-Plugin"], Package["nagios-plugins"], Class["yum"] ],
	}
	# track check_iptables
	file { "check_iptables":
		name       => "/usr/${libfolder}/nagios/plugins/check_iptables",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0550',
		source     => "puppet:///nagios/check_iptables.sh",
		require    => Package["nagios-plugins"],
	}
	# track check_clamav
	file { "check_clamav":
		name       => "/usr/${libfolder}/nagios/plugins/check_clamav",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0550',
		source     => "puppet:///nagios/check_clamav.sh",
		require    => Package["nagios-plugins"],
	}
	# track check_memory
	file { "check_memory":
		name       => "/usr/${libfolder}/nagios/plugins/check_memory",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0550',
		source     => "puppet:///nagios/check_memory.pl",
		require    => Package["nagios-plugins"],
	}
	# track check_replication
	file { "check_replication.pl":
		name       => "/usr/${libfolder}/nagios/plugins/check_replication.pl",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0550',
		source     => "puppet:///nagios/check_replication.pl",
		require    => Package["nagios-plugins"],
	}
	file { "check_replication.sh":
		name       => "/usr/${libfolder}/nagios/plugins/check_replication.sh",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'root',
		group      => 'nagios',
		mode       => '0550',
		source     => "puppet:///nagios/check_replication.sh",
		require    => Package["nagios-plugins"],
	}
}
