class grayskull::service {

  case $::operatingsystem {
    'debian','ubuntu': {
      file{ '/etc/init.d/grayskull':
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/grayskull/grayskull_initscript',
      }

      service{ 'grayskull':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => File['/etc/init.d/grayskull'],
      }
    }
  }

}
