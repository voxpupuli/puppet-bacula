class puppetlabs::os::linux::centos {

  yumrepo { 'epel':
    descr      => "Extra Packages for Enterprise Linux ${lsbmajdistrelease} - $basearch",
    mirrorlist => "mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${lsbmajdistrelease}&arch=\$basearch",
    enabled    => 1,
    gpgcheck   => 1,
    keepalive  => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
  }

  case $domain {
    "puppetlabs.lan": {
      yumrepo { 'puppetlabs_os':
        descr      => "Puppetlabs Internal OS Mirror Linux ${lsbdismajrelease} - \$basearch",
        baseurl    => "http://yo.puppetlabs.lan/cent${lsbmajdistrelease}server-$architecture/RPMS.os",
        enabled    => 1,
        gpgcheck   => 1,
        keepalive  => 1,
      }
    default: {}
  }
}

