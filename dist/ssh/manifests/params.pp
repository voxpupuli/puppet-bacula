class ssh::params {

 case $operatingsystem {
    'centos', 'redhat', 'fedora': {
      $client_package    = 'openssh-clients'
      $server_package    = 'openssh-server'
      $ssh_service       = 'sshd'
      $sshd_config       = '/etc/ssh/sshd_config'
      $ssh_config       = '/etc/ssh/ssh_config'
    }
    'sles': {
      $client_package    = 'openssh'
      $server_package    = 'openssh'
      $ssh_service       = 'sshd'
      $sshd_config       = '/etc/ssh/sshd_config'
      $ssh_config       = '/etc/ssh/ssh_config'
    }
    'ubuntu', 'debian': {
      $client_package    = 'openssh-client'
      $server_package    = 'openssh-server'
      $ssh_service       = 'ssh'
      $sshd_config       = '/etc/ssh/sshd_config'
      $ssh_config       = '/etc/ssh/ssh_config'
    }
    'darwin': {
      $ssh_service = 'com.openssh.sshd'
      $ssh_config  = '/etc/ssh_config'
      $sshd_config = '/etc/sshd_config'
    }
    default: {
      fail("module ssh does not support operatingsystem $operatingsystem")
    }
  }
}
