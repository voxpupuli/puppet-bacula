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
define account::user ($ensure='present', $comment, $shell='/bin/bash', $home='' , $group='', $groups='', $test='false'){
  
	if $test == true { # what does this even do?
    $userdir = "puppet:///modules/account/${name}"
    group { $groupname: ensure => $ensure }
  }
  else {
    $userdir = "puppet:///modules/site-files/userdirs/${name}"
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
			default => "/home/${name}",
			Darwin => "/Users/${name}",
		}
  }
  
	$setpass = setpass($name)
  
	user { $name: # do stuff
    groups => $groups,
    gid => $groupname,
    ensure => $ensure,
    comment => $comment,
    home => $homedir,
    managehome => $kernel ? {
			Darwin => false,
			default => true,
		},
    password => $setpass ? {
      '' => undef,
      default => $setpass,
    },
    shell => $shell,
  }

  File { owner => $name, group => $groupname}
  file {
    "${homedir}": ensure => directory, source => $userdir;
  #  "${homedir}/.ssh/": mode => 700, ensure => directory, owner => $name, group => $groupname;
  #  "${homedir}/.ssh/authorized_keys": mode => 644, recurse => true, source => "${userdir}/.ssh/authorized_keys", owner => $name, group => $groupname;
  }
  #
  # Add AllowUser line fragment to sshd_config.
  #
  #fragment { "sshd_config_AllowUsers-${name}":
  #  path => "/etc/ssh",
  #  target => "sshd_config",
  #  content => "AllowUsers ${name}\n",
  #}
}

