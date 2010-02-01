define account::user ($ensure='present', $comment, $password, $shell='/bin/bash', $home='' , $group='', $groups=''){
  #
  # Creating an ssh user so we must require ssh::server.
  #
  include ssh::server
  #
  # requires expects a userdir module that is managed by git. 
  #
  $userdir = "puppet:///site-files/userdirs/${name}"
  #
  # Setting the groupname.
  #
  if $group {
    $groupname = $group
    Group <| name == $group |>
  } else {
    $groupname = undef 
  }
  #
  # Setting home. 
  #
  if $home {
    $homedir = $home 
  } else {
    $homedir = "/home/${name}" 
  }  
  #
  # Add finally the create the user.
  #
  user { $name:
    groups => $groups,
    gid => $groupname,
    ensure => $ensure,
    comment => $comment,
    home => $homedir,
    managehome => true,   
    password => $password,
    shell => $shell,
  }
  group { $groupname: ensure => $ensure }
  File { owner => $name, group => $groupname}
  file {
    "${homedir}": recurse => true, ensure => directory, source => $userdir;
    "${homedir}/.ssh/": mode => 700, ensure => directory;
    "${homedir}/.ssh/authorized_keys": mode => 644, recurse => true, source => "${userdir}/.ssh/authorized_keys";
  }
  #
  # Add AllowUser line fragment to sshd_config.
  #
  fragment { "sshd_config_AllowUsers-${name}":
    path => "/etc/ssh",
    target => "sshd_config",
    content => "AllowUsers ${name}",
  }
}
