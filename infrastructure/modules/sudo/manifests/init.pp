# sudo class
class sudo {
  package { "sudo": ensure => present }
  file{"/etc/sudoers": 
    owner   => "root", 
    group   => "root", 
    mode    => "400",
    source  => "puppet:///sudo/sudoers",
  }
}
