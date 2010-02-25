yumrepo { 'xapian':
    baseurl => '
        http://www.xapian.org/RPM/rhel5/i386/',
    enabled => '1',
    gpgcheck => '1',
    gpgkey => 'http://rpm.eprints.org/RPM-GPG-KEY-tdb01r',
    descr => 'Xapian for RHEL5 - $basearch - Base'
}
yumrepo { 'xapian-source':
    baseurl => '
        http://www.xapian.org/RPM/rhel5/SRPMS/',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'http://rpm.eprints.org/RPM-GPG-KEY-tdb01r',
    descr => 'Xapian for RHEL4 - $basearch - Source'
}
yumrepo { 'local-noarch':
    baseurl => 'http://yum.reductivelabs.net/yum/$releasever/base/noarch/',
    enabled => '1',
    keepalive => '1',
    gpgcheck => '0',
    descr => 'Local - Base repo noarch'
}
yumrepo { 'epel-testing':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-epel5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - Testing - $basearch '
}
yumrepo { 'epel-testing-debuginfo':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-debug-epel5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - Testing - $basearch - Debug'
}
yumrepo { 'epel-testing-source':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-source-epel5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - Testing - $basearch - Source'
}
yumrepo { 'epel':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '1',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - $basearch'
}
yumrepo { 'epel-debuginfo':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-debug-5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - $basearch - Debug'
}
yumrepo { 'epel-source':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-5&arch=$basearch',
    failovermethod => 'priority',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
    descr => 'Extra Packages for Enterprise Linux 5 - $basearch - Source'
}
yumrepo { 'base':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Base'
}
yumrepo { 'updates':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Updates'
}
yumrepo { 'addons':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=addons',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Addons'
}
yumrepo { 'extras':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Extras'
}
yumrepo { 'centosplus':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Plus'
}
yumrepo { 'contrib':
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Contrib'
}
yumrepo { 'c5-media':
    baseurl => 'file:///media/CentOS/
        file:///media/cdrom/
        file:///media/cdrecorder/',
    enabled => '0',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
    descr => 'CentOS-$releasever - Media'
}
yumrepo { 'local-arch':
    baseurl => 'http://yum.reductivelabs.net/yum/$releasever/base/$basearch/',
    enabled => '1',
    keepalive => '1',
    gpgcheck => '0',
    descr => 'Local Base repo arch'
}
