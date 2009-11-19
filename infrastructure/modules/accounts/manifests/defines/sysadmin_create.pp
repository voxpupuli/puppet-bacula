# Copyright 2009 Larry Ludwig (larrylud@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License"); you 
# may not use this file except in compliance with the License. You 
# may obtain a copy of the License at 
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express 
# or implied. See the License for the specific language governing 
# permissions and limitations under the License. 
#
define sysadmin_create ($comment, $password, $shell='/bin/bash') {
	group { "${title}":
		ensure     => present,
	}
	user { "${title}":
		name       => "${title}",
		gid        => "${title}",
		groups     => 'sysadmin',
		ensure     => present,
		comment    => "${comment}",
		home       => "/home/${title}",
		managehome => true,
		password   => "${password}",
		shell      => "${shell}",
		require    => [ Group["${title}"], Group["sysadmin"] ],
	}
	# add to sshd_config file
	/*
	ensure_line { "sshd_config_AllowUsers-${title}":
		file    => "/etc/ssh/sshd_config",
		line    => "AllowUsers ${title}",
		pattern => "^AllowUsers ${title}$",
		require => [ File["sshd_config"], User["${title}"] ],
		notify  => Service["sshd"],
	}
	*/
	file { "/home/${title}":
		owner    => "${title}",
		group    => "${title}",
		mode     => '0700',
		ensure   => directory,
		require  => User["${title}"],
	}
	file { "/home/${title}/.ssh":
		owner    => "${title}",
		group    => "${title}",
		mode     => '0700',
		ensure   => directory,
		require  => [ User["${title}"], File["/home/${title}"] ],
	}
	file { "/home/${title}/.ssh/authorized_keys2":
		ensure   => absent,
	}
	file { "/home/${title}/.ssh/authorized_keys":
		owner    => "${title}",
		group    => "${title}",
		mode     => "0400",
		checksum => md5,
		ensure   => present,
		source   => "puppet:///accounts/${title}/authorized_keys.conf",
		require  => [ User["${title}"], File["/home/${title}/.ssh/authorized_keys2"], File["/home/${title}"], File["/home/${title}/.ssh"] ],
	}
}
