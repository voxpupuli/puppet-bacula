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
class mysql {
	# remove CentOS/RHEL rpms
	package { "mysql-server":
		ensure => absent,
	}
	package { "MySQL-server-standard":
		ensure => absent,
	}
	package { "MySQL-shared-compat":
		ensure => absent,
	}
	package { "MySQL-client-standard":
		ensure  => absent,
	}
	package { "MySQL-devel-standard":
		ensure => absent,
	}
	package { "perl-DBD-MySQL":
		ensure  => absent,
		require => Package["mysql-server"],
	}
	package { "mysql-devel":
		ensure  => absent,
		require => Package["perl-DBD-MySQL"],
	}
	package { "mysql-bench":
		ensure  => absent,
		require => Package["mysql-devel"],
	}
	exec { "remove-mysql":
		name      => "rpm -e mysql --nodeps",
		logoutput => on_failure,
		onlyif    => "rpm -q mysql",
	}
	package { "MySQL-devel-community":
		require => Exec["remove-mysql"],
	}
	package { "MySQL-shared-community":
		require => Package["MySQL-devel-community"],
	}
	package { "MySQL-client-community":
		require => Package["MySQL-shared-community"],
	}
	package { "perl-DBD-mysql":
		require => Package["MySQL-client-community"],
	}
	# track my.cnf changes 
	file { "/etc/my.cnf":
		checksum => md5,
		owner    => 'root',
		group    => 'root',
		mode     => '0644',
		backup   => local,
		require  => Package["MySQL-client-community"],
	}
}
