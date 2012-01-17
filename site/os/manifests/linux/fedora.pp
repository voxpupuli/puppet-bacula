class os::linux::fedora {

  package {
    "redhat-lsb": ensure => installed;
  }

  yumrepo { 'puppetlabs':
    descr      => "Puppet Labs",
    baseurl    => "http://yum.puppetlabs.com/fedora/f${lsbdistrelease}/products/${architecture}/",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs'
  }

}

