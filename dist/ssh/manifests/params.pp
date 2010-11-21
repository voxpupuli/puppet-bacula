class ssh::params {
 case $operatingsystem {
    'centos', 'redhat', 'fedora': {
      $sshclient_package='openssh-clients'
      $ssh_service='sshd'
    }
    'ubuntu', 'debian': {
      $sshclient_package='openssh-client'
      $ssh_service='ssh'
    }
 }

}
