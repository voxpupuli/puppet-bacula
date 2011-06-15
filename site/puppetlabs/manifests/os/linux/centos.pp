class puppetlabs::os::linux::centos {


  resources {
    "yumrepo":
      purge => true;
  }

  yumrepo { 'epel':
    descr      => "Extra Packages for Enterprise Linux ${lsbmajdistrelease} - \$basearch",
    mirrorlist => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${lsbmajdistrelease}&arch=\$basearch",
    enabled    => 1,
    gpgcheck   => 1,
    keepalive  => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
  }

  case $domain {
    "puppetlabs.lan": {
      yumrepo { 'puppetlabs_os':
        descr      => "Puppetlabs Internal OS Mirror Linux ${lsbmajdistrelease} - \$basearch",
        baseurl    => "http://yo.puppetlabs.lan/cent${lsbmajdistrelease}server-$architecture/RPMS.os",
        enabled    => 1,
        gpgcheck   => 1,
        keepalive  => 1,
      }
      yumrepo { 'puppetlabs_updates':
        descr      => "Puppetlabs Internal Updates Mirror Linux ${lsbmajdistrelease} - \$basearch",
        baseurl    => "http://yo.puppetlabs.lan/cent${lsbmajdistrelease}server-$architecture/RPMS.updates",
        enabled    => 1,
        gpgcheck   => 1,
        keepalive  => 1,
      }
    }
    default: {}
  }
}

