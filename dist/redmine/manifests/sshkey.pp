# this class drops the sshkey in place so that we can clone from github
class redmine::sshkey {

  if $kernel == 'Linux' {

      file{
          '/root/.ssh':
              ensure =>  directory , owner => 'root';
          '/root/.ssh/github_redmine':
              ensure  => file,
              owner   => 'root',
              mode    => '0600',
              source  => 'puppet:///modules/redmine/github_redmine.sshkey',
              require => File['/root/.ssh'];
          '/root/.ssh/config':
              ensure  => file,
              owner   => 'root',
              mode    => '0600',
              source  => 'puppet:///modules/redmine/github_ssh_config',
              require => File['/root/.ssh'];
      }

      # Manage known_hosts too. This _may_ get out of date, but at
      # least for now it works, which is better than not at all.
      sshkey { 'github.com':
        ensure => present,
        type   => 'ssh-dss',
        key    => 'AAAAB3NzaC1kc3MAAACBAK791BulMyD4xgZUtrROnpuNYPNyNcgrw+2Dbe0FOZV06WiKVA1hLzGqF5Y6k2v61X7VyaCL6l632dUY+6IeNlRqLpBPB7Yyr4lKRpZBiAp1vAiT2Ifx09+algN4p77KkpophV057vNtlNWuDdkNW7Ca4VRa9nEDbxH1lwekSPwZAAAAFQC0CMCU0NIjuwMHd+OLQFp97E86AwAAAIByoDnV0IG/+1eW8NAEUAj+BO9YIoe79C6iqbrdY2EFN87+WAUgrSVfd/+xVn5T86PsHRj0+zhtuSLo/+/q0TszFsJ6gOg0Ox9iSu06Q9XrMT8DITzhrAhiE0WqxvfuFvSq33a1xQ2WouMVnUKkeRdZwIY8HeG8Q13HREO+Vru0+wAAAIEApBcnba4CJrFMSCzVM5t32YFo0Ntow+KdXBUyPXJ/kbo8nh39guX2xIYQmPPkrOmpHBUTEdKwhb52ewB0DGkOLu4FgYLhVyUNAJgXdz+kv4pRE02hcKXkS1/tyJwMM24fE31WoUwaxtbijYhQrB6UduZPNTugYi1knqz2Hr7P06o=',
      }

  } else {
      warning( "Not messing with Forge/github SSH key antics on $hostname/$kernel" )
  }

}
