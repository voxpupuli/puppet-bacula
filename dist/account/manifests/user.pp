define account::user ($ensure='present', $comment, $shell='/bin/bash', $home='' , $group='', $groups='', $test='false'){
  #
  # Creating an ssh user so we must require ssh::server.
  #
  include ssh::server
  #
  # requires expects a userdir module that is managed by git. 
  # group is set here for testing as well.  
  #
  if $test == true {
    $userdir = "puppet:///modules/account/${name}"
    group { $groupname: ensure => $ensure }
  }
  else {
    $userdir = "puppet:///modules/site-files/userdirs/${name}"
  }
    
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
    #password => setpass($name),
    shell => $shell,
  }
  File { owner => $name, group => $groupname}
  file {
    "${homedir}": recurse => true, ensure => directory, source => $userdir;
    "${homedir}/.ssh/": mode => 700, ensure => directory, owner => $name, group => $groupname;
    "${homedir}/.ssh/authorized_keys": mode => 644, recurse => true, source => "${userdir}/.ssh/authorized_keys", owner => $name, group => $groupname;
  }
  #
  # Add AllowUser line fragment to sshd_config.
  #
  fragment { "sshd_config_AllowUsers-${name}":
    path => "/etc/ssh",
    target => "sshd_config",
    content => "AllowUsers ${name}\n",
  }
}
