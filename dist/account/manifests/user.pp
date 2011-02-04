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

define account::user ($ensure='present', $comment, $shell='/bin/bash', $home='' , $group='', $groups='', $test='false', $uid ='',usekey=true){
	include packages::shells
  
	if $test == true { # what does this even do?
    $userdir = "puppet:///modules/account/${name}"
    group { $groupname: ensure => $ensure }
  }
  else {
    $userdir = "puppet:///modules/site-files/userdirs/${name}"
  }

	if $shell == '/bin/zsh' {
	  Package <| title == 'zsh' |>
	}
    
  if $group { # realize needed groups
    $groupname = $group
    Group <| name == $group |>
  } else {
    $groupname = undef 
  }

	if $groups {
		$grouplist = $groups
		realize(Group[$grouplist])
  } else {
    $grouplist = undef 
  }

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
  
	$setpass = setpass($name)
  
	user { $name: # do stuff
    gid        => $groupname,
		uid        => $userid,
    home       => $homedir,
    ensure     => $ensure,
    groups     => $groups,
    comment    => $comment,
		managehome => false,
    password => $setpass ? {
      ''      => undef,
      default => $setpass,
    },
    shell => $shell,
  }

	if $ensure == 'present' {
	  File { owner => $name, group => $groupname}
	  file {
	    "${homedir}": ensure => directory, owner => $name, group => $groupname, source => $userdir, require => User["$name"];
		}
		if $usekey == true {
			file {
  	    "${homedir}/.ssh/": mode => 700, ensure => directory, owner => $name, group => $groupname, require => User["$name"];
  	    "${homedir}/.ssh/authorized_keys": mode => 644, recurse => true, source => "${userdir}/.ssh/authorized_keys", owner => $name, group => $groupname, require => User["$name"];
      }
    }
	}

}

