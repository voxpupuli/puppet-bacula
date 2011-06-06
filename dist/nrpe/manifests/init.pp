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
class nrpe {
  case $operatingsystem {
    centos, redhat: { include nrpe::redhat }
    debian, ubuntu: { include nrpe::debian }
    default:        { fail("nrpe is not defined for this operating system.") }
  }
  # track nrpe.local.cfg changes 
  # for command for that specific machine (not required)
  file { "nrpe.local.cfg":
    name       => "/etc/nagios/nrpe.local.cfg",
    checksum   => md5,
    ensure     => present,
    replace    => true,
    owner      => 'nagios',
    group      => 'nagios',
    mode       => '0400',
    source     => [
      "puppet:///nrpe/hosts/nrpe.local.${fqdn}.cfg",
      "puppet:///nrpe/hosts/nrpe.local.${hostname}.cfg",
      "puppet:///nrpe/nrpe.local.cfg"
    ],
    notify     => Service["nrpe"],
  }
}
