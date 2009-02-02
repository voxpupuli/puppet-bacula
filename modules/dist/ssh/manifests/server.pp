# setup ssh server
class ssh::server inherits ssh {
  package { "ssh-server":
    name => $operatingsystem ? {
    redhat  => "openssh-server",
    default => "openssh-server",
    },
    ensure => present,
  }
  file {
    '/etc/ssh/sshd_config': owner => "root", group => "root", mode => "644", source => "puppet:///ssh/sshd_config", require => Package["ssh-server"];
  }
  service { "sshd":
    enable      => "true",
    ensure      => "running",
    subscribe   => [ Package["ssh-server"], File["/etc/ssh/sshd_config"] ],
    require     => Package["ssh-server"],
  }
  @@sshkey { "$fqdn": type => rsa, key => $sshrsakey }
  Sshkey <<||>>
  resources { sshkey: purge => true }
}
