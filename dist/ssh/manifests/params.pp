class ssh::params {

 case $operatingsystem {
    'centos', 'redhat', 'fedora': {
      $sshclient_package='openssh-clients'
      $ssh_service='sshd'
      $ssh_config = '/etc/ssh/ssh_config'
      $sshd_config = '/etc/ssh/sshd_config'
    }
    'sles': {
      $sshclient_package='openssh'
      $ssh_service='sshd'
      $sshd_config = '/etc/ssh/sshd_config'
    }
    'ubuntu', 'debian': {
      $sshclient_package='openssh-client'
      $ssh_service='ssh'
      $ssh_config = '/etc/ssh/ssh_config'
      $sshd_config = '/etc/ssh/sshd_config'
    }
    'darwin': {
      $ssh_service = 'com.openssh.sshd'
      $ssh_config = '/etc/ssh_config'
      $sshd_config = '/etc/sshd_config'
    }
  }

}
