# Definition: account::user
#
# This class installs and manages user accounts
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

define account::user (
    $ensure='present', 
    $comment, 
    $shell='/bin/bash', 
    $home='' , 
    $group='', 
    $groups='', 
    $test='false', 
    $uid ='', 
    $usekey=true, 
    $key='',
    $keytype='',
    $email='',
    $expire=''
    ){

  include packages::shells

  if $test == true { # what does this even do?
    $userdir = "puppet:///modules/account/${name}"
    group { $groupname: ensure => $ensure }
  }
  else {
    $userdir = "puppet:///modules/site-files/userdirs/${name}"
  }

  # Manage Shells
  if $shell == '/bin/zsh' {
    Package <| title == 'zsh' |>
  }

  # realize needed groups
  if $group { 
    $groupname = $group
    Group <| title == $group |>
  } else {
    $groupname = undef 
  }

  if $groups {
    $grouplist = $groups
    realize(Group[$grouplist])
  } else {
    $grouplist = undef 
  }

  # Test if we are managing home directories
  if $home { # Set home
    $homedir = $home 
  } else {
    $homedir = $kernel ? {
      Darwin  => "/Users/${name}",
      default => "/home/${name}",
    }
  }

  if $uid {
    $userid = $uid
  } else {
    $userid = undef
  }

  if $setpass {
    $setpass = setpass($name)
    $password = $setpass
  } else {
    $password = undef
  }

  if $expire {
    $expiry = $expire
  } else {
    $expiry = undef
  }


  user { 
    $name: # do stuff
      gid        => $groupname,
      uid        => $userid,
      home       => $homedir,
      ensure     => $ensure,
      groups     => $groups,
      comment    => $comment,
      managehome => false,
      password   => $password,
      shell      => $shell,
      expiry     => $expire,
  }

  # Only if we are ensuring a user is present
  if $ensure == 'present' {
    File { owner => $name, group => $groupname}
    file {
      "${homedir}": ensure => directory, require => User["$name"];
    }

    # Only if we are using key auth
    if $usekey == true {
      if $key { 
        ssh_authorized_key { "$name@$group":
          ensure => present,
          key    => $key,
          type   => $keytype,
          user   => $name,
        }
      } else {
        file {
          "${homedir}/.ssh/": 
            mode    => 700, 
            ensure  => directory, 
            owner   => $name, 
            group   => $groupname, 
            require => User["$name"];
          "${homedir}/.ssh/authorized_keys": 
            mode    => 644, 
            recurse => true, 
            source  => "${userdir}/.ssh/authorized_keys", 
            owner   => $name, 
            group   => $groupname, 
            require => User["$name"];
        }
      }
    }
  }
}

