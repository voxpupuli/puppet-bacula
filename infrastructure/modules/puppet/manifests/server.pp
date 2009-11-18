class puppet::server inherits puppet {
  package{'puppet-server':}
  service{'puppetmaster':
    ensure => running,
    enable => true,
  }
  file{'/etc/puppet/namespaceauth.conf':
    source => 'puppet:///puppet/namespaceauth.conf',
  }
  file{'/etc/puppet/puppet.conf':
    content => template('puppet/puppet.conf.erb'),
    notify  +> Service['puppetmaster'],
  }
  # /etc/sysconfig/puppetmaster - what is this??
}
