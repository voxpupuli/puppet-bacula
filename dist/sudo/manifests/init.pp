# sudo class
class sudo {
  package { "sudo": ensure => present }
  file{"/etc/sudoers": 
    owner   => "root", 
    group   => "root", 
<<<<<<< HEAD:dist/sudo/manifests/init.pp
    mode    => "440",
    source  => "puppet:///modules/site-files/sudoers",
=======
    mode    => "400",
    source  => "puppet:///modules/sudo/sudoers",
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/sudo/manifests/init.pp
  }
}
