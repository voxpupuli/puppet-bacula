class yum::epel {
  include yum
  yumrepo { 'epel':
    descr => 'Extra Packages for Enterprise Linux 5 - $basearch',
    mirrorlist => "mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=\$basearch",
    enabled    => 1,
    gpgcheck   => 1,
    keepalive  => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
  }
} 
