class os::linux::centos {

  include cron

#  resources {
#    "yumrepo":
#      purge => true;
#  }

  package {
    "redhat-lsb": ensure => installed;
  }

  yumrepo { 'epel':
    descr      => "Extra Packages for Enterprise Linux ${lsbmajdistrelease} - \$basearch",
    mirrorlist => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${lsbmajdistrelease}&arch=\$basearch",
    enabled    => 1,
    gpgcheck   => 1,
    keepalive  => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
  }

  yumrepo { 'puppetlabs':
    descr      => "Puppet Labs",
    baseurl    => "http://yum.puppetlabs.com/el/5/products/$architecture/",
    enabled    => 1,
    gpgcheck   => 1,
    keepalive  => 1,
    gpgkey     => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs'
  }

  case $domain {
    "puppetlabs.lan": {
      yumrepo { 'puppetlabs_os':
        descr      => "Puppetlabs Internal OS Mirror Linux ${lsbmajdistrelease} - \$basearch",
        baseurl    => "http://yo.puppetlabs.lan/cent${lsbmajdistrelease}latestserver-$architecture/RPMS.os",
        enabled    => 1,
        gpgcheck   => 1,
        keepalive  => 1,
      }
      yumrepo { 'puppetlabs_updates':
        descr      => "Puppetlabs Internal Updates Mirror Linux ${lsbmajdistrelease} - \$basearch",
        baseurl    => "http://yo.puppetlabs.lan/cent${lsbmajdistrelease}latestserver-$architecture/RPMS.updates",
        enabled    => 1,
        gpgcheck   => 1,
        keepalive  => 1,
      }
    }
    default: {}
  }

  # Make logwatch not run, we have other monitoring for that (famous
  # last words).
  file{ '/etc/cron.daily/0logwatch':
    ensure => absent,
  }

}
