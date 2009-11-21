class yum{
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
  }
} 
