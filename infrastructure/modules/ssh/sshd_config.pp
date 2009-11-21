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
# either add or remove sshd_config options
define sshd_config ($file = '', $name, $value = '', $ensure = 'present') {
	case $ensure {
		default : { err ( "unknown ensure value ${ensure}" ) }
		present: {
			ensure_line { "sshd_config--${name}--$value":
				file    => $file ? { "" => "/etc/ssh/sshd_config", default => $file},
				line    => "${name} ${value}",
				pattern => "^${name} .+$",
				require => File['sshd_config'],
				notify  => Service['sshd'],
			}
		}
		absent: {
			ensure_line { "sshd_config--${name}--absent":
				file    => $file ? { "" => "/etc/ssh/sshd_config", default => $file},
				pattern => $name,
				ensure  => absent,
				require => File['sshd_config'],
				notify  => Service['sshd'],
			}
		}
	} 
}
