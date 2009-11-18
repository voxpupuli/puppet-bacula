class puppet {
  package{'puppet':}
  # I wont start puppet as a cron job, I trust our code :)
  service{'puppet':
    ensure => running,
    enable => true,
  }
  file{'/etc/puppet/puppet.conf':
    content => template('puppet/puppet.conf.erb'),
    notify  => Service['puppetmaster'],
  }
  # /etc/sysconfig/puppetmaster - what is this??
}
