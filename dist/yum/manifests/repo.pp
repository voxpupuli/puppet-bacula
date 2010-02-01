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
# creates a yum repo
class yum::repo {
  include apache::ssl
  # yum::repo::username to use
  $yum_user = 'yum'
  # where to store the repo
  $yum_home = "/home/${yum_user}"

  group { $yum_user:
    ensure     => present,
  }
  user { $yum_user:
    ensure     => present,
    gid        => $yum_user,
    comment    => 'yum repo',
    home       => $yum_home,
    managehome => true,
    shell      => '/sbin/nologin',
  }
  file{$yum_home:
    owner  => yum,
    group  => yum,
    mode   => 755,
    ensure => directory,
  }
  # make sure home folder is proper perms
  # make sure home folder is proper perms
  file { "/etc/httpd/conf.d/yum.conf":
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    ensure => present,
    content    => template('yum/yum.conf.erb'),
    notify     => Service['httpd'],		
    require    => Package['httpd'],
  }
  package { "createrepo":}
  # yum repos to create
  yumrepoversion { [3, 4, 5] :
    reponame => "base",	
    user     => $yum_user,
    home     => $yum_home,
    require  => Package['createrepo']
  }
}

define yumrepoversion ($reponame, $user, $home) { 
  # setup the version 
  File{
    owner => $user,
    group => $user,
    mode  => 644,
  }
  file { ["${home}/${name}", 
          "${home}/${name}/SRPMS", 
          "${home}/${name}/${reponame}"
         ]: 
         ensure     => directory,
  }
  # create the distro types
  Yumrepoarch{
    version  => $name,
    reponame => $reponame,
    home     => $home,
    user     => $user,
  }
  yumrepoarch { "${name}-${reponame}-noarch":
    arch     => 'noarch',
  }
  yumrepoarch { "${name}-${reponame}-i386":
    arch     => 'i386',
  }
  yumrepoarch { "${name}-${reponame}-x86_64":
    arch     => 'x86_64',
  }
}

# create arch for specific repo
define yumrepoarch ($version, $reponame, $arch,$home, $user) {
  $repo_dir = "${home}/${version}/${reponame}/${arch}"
  File{
    owner => $user,
    group => $user,
    mode  => 0644,
  }
  file{$repo_dir:
    ensure => directory,
  }
  file { ["${repo_dir}/RPMS", "${repo_dir}/repodata" ]:
    ensure  => directory,
    recurse => true,
    require => Exec["createrepo-${repo_dir}"],
  }
  # uupdate the yum repo if a file changes in the folder
  exec { "createrepo-${repo_dir}":
    path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
    command     => "createrepo -q -p $repo_dir",
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => File[$repo_dir],
  }
}
