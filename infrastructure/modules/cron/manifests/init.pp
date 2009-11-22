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
# $Id$
#
# installs vixie-cron 
class cron {
  package {['vixie-cron', 'crontabs']:
    ensure => installed,
    notify => Service["crond"],
  }
  file { "/etc/crontab":
    owner   => root,
    group   => root,
    mode    => '0400',
    source  => "puppet:///modules/cron/crontab",
    require => Package["crontabs"],
    notify  => Service["crond"],
  }
  # make sure crond is running
  service { "crond":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
