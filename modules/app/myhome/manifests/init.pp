class myhome {
   if $operatingsystem == Darwin {
     $homedir = "/user/teyo" 
   } else {
     $homedir = "/home/$id" 
   }
   
   file {
     "$homedir/.ssh": ensure => directory, mode => 700;
     "$homedir/.ssh/.authorized_keys": ensure => present, mode => 644, source => 'puppet:///myhome/authorized_keys';
     "$homedir/.bash_profile": ensure => present, mode => 644, source => 'puppet:///myhome/bash_profile';
     "$homedir/.bashrc": ensure => present, mode => 644, source => 'puppet:///myhome/bashrc';
     "$homedir/.vimrc": ensure => present, mode => 644, source => 'puppet:///myhome/vimrc';
   }   
}
