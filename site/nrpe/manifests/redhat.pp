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
# install nagios nrpe
# PROCESS:
# - removes nrpe-supplemental (our old method to configure nrpe)
# - makes sure nrpe is installed
# - installs our config files
# - makes sure the service is running and will start upon boot
class nrpe::redhat {
	package { "nagios-nrpe":
		notify     => Service["nrpe"],
		require    => Class["nagios"],
	}
	# track nrpe.conf changes 
	file { "nrpe.cfg":
		name       => "/etc/nagios/nrpe.cfg",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'nagios',
		group      => 'nagios',
		mode       => '0400',
		content    => template("nrpe/nrpe.cfg.erb"),
		require    => Package["nagios-nrpe"],
		notify     => Service["nrpe"],
	}
	# track nrpe.commands.cfg changes 
	file { "nrpe.commands.cfg":
		name       => "/etc/nagios/nrpe.commands.cfg",
		checksum   => md5,
		ensure     => present,
		replace    => true,
		owner      => 'nagios',
		group      => 'nagios',
		mode       => '0400',
		source     => "puppet:///nrpe/nrpe.commands.${architecture}.cfg",
		require    => [ Package["nagios-nrpe"], Class["sudo"] ],
		notify     => Service["nrpe"],
	}
   	# make sure nrpe is setup to run
	service { "nrpe":
		name       => "nrpe",
		ensure     => running,
		enable     => true,
		hasrestart => true,
		require    => [ Package["nagios-nrpe"], File["nrpe.cfg"], File["nrpe.commands.cfg"] ],
	}
}
