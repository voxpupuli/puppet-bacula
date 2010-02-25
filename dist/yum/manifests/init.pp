class yum{
<<<<<<< HEAD:dist/yum/manifests/init.pp
  if(! $yum_repo) {
    fail("\$yum_repo must be defined")
  }
  package{['yum', 'yum-priorities']:
    ensure => latest,
  }
  yumrepo { "local-arch":
    descr   => "Local Base repo arch",
    baseurl => "http://${yum_repo}/yum/\$releasever/base/\$basearch/",
    enabled   => 1,
    gpgcheck  => 0,
    keepalive => 1,
  }
  yumrepo { "local-noarch":
    descr     => "Local - Base repo noarch",
    baseurl   => "http://${yum_repo}/yum/\$releasever/base/noarch/",
    enabled   => 1,
    gpgcheck  => 0,
    keepalive => 1,
=======
  package{['yum', 'yum-priorities']:
    ensure => latest,
  }
  $yumdir = '/etc/yum.repos.d'
  File{owner => 'root', group => 'root', mode => '0644'}
  file {$yumdir: 
    ensure => directory, 
    purge => true,
    recurse => true,
  }
  file{
    "${yumdir}/epel.repo":
      source => 'puppet:///yum/epel.repo';
    "${yumdir}/epel-testing.repo":
      source => 'puppet:///yum/epel-testing.repo';
    "${yumdir}/CentOS-Base.repo":
      source => 'puppet:///yum/CentOS-Base.repo';
#    "${yumdir}/CentOS-Media.repo":
#      source => 'puppet:///yum/CentOS-Media.repo';
    "${yumdir}/local-arch.repo":
      source => 'puppet:///yum/local-arch.repo';
    "${yumdir}/local-noarch.repo":
      source => 'puppet:///yum/local-noarch.repo';
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/yum/manifests/init.pp
  }
} 
