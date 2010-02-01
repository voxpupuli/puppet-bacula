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
class nagios {
  include yum
  Package{
    ensure  => installed,
  }
  package { "nagios-plugins":
    require => Class["yum"],
  }
  package {[ "nagios-moreplugs",
	     # allow for restarting of services via eventhandlers
             "nagios-eventhandlers",
	     "nagios-plugins-filerc",
	     # Empowering Media's TCP port monitoring
             "nagios-plugins-ports",
	     # Empowering Media's TCP rouge process monitoring
	     "nagios-plugins-rogue",
	     "perl-Nagios-Plugin",
	     "perl-Config-Tiny",
            ]:
    require => [ Class["yum"], Package["nagios-plugins"] ],
  }
  package { "nagios-of-plugins":
    require => [ Package["perl-Config-Tiny"], 
                 Package["perl-Nagios-Plugin"], 
               ],
  }
  File{
    ensure   => present,
    replace  => true,
    owner    => 'root',
    group    => 'nagios',
    mode     => '0550',
    require  => Package["nagios-plugins"],
  }
  # track check_iptables
  file { "check_iptables":
    name  => "/usr/${libfolder}/nagios/plugins/check_iptables",
    replace    => true,
    mode       => '0550',
    source     => "puppet:///nagios/check_iptables.sh",
  }
  # track check_clamav
  file { "check_clamav":
    name   => "/usr/${libfolder}/nagios/plugins/check_clamav",
    source => "puppet:///nagios/check_clamav.sh",
  }
  # track check_memory
  file { "check_memory":
    name   => "/usr/${libfolder}/nagios/plugins/check_memory",
    source => "puppet:///nagios/check_memory.pl",
  }
  # track check_replication
  file { "check_replication.pl":
    name   => "/usr/${libfolder}/nagios/plugins/check_replication.pl",
    source => "puppet:///nagios/check_replication.pl",
  }
  file { "check_replication.sh":
    name   => "/usr/${libfolder}/nagios/plugins/check_replication.sh",
    source => "puppet:///nagios/check_replication.sh",
  }
}
