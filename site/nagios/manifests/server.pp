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
class nagios::server inherits nagios{
  include apache::ssl, mailx, yum
  File{
    checksum   => md5,
    ensure     => present,
    replace    => true,
    owner      => 'root',
    group      => 'nagios',
    mode       => '0440',
    require    => Package["nagios"],
    notify     => Service["nagios"],
  }
  # install commands.cfg
  file { "/etc/nagios/commands.cfg":
  source => "puppet:///nagios/commands.cfg",
  }
	# install event_handlers.cfg
  file { "/etc/nagios/event_handlers.cfg":
    source => "puppet:///nagios/event_handlers.cfg",
  }
  # install timeperiods.cfg
  file { "/etc/nagios/timeperiods.cfg":
    source     => "puppet:///nagios/timeperiods.cfg",
  }
  # make sure resource.cfg has proper perms
  file { "/etc/nagios/private/resource.cfg":
		mode       => '0640',
  }
  package { "nagios":
    notify  => Service["nagios"],
    require => [ Class["yum"], Class["apache::ssl"], Class["mailx"] ],
  }
  # allow for NRPE communciation
  package { "nagios-plugins-nrpe":
    require    => [ Package["nagios"], Package["nagios-plugins"] ],
  }
	# make sure our nagios.conf is installed 
  file { "/etc/httpd/conf.d/nagios.conf":
    source => "puppet:///nagios/nagios.conf",
    group  => 'root',
    notify => undef,
  }
	# monitor htpasswd.users
  file { "/etc/nagios/htpasswd.users":
    mode       => '0640',
  }
  # make sure nagios is setup to run
  service { "nagios":
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }
}
