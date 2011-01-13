define ssh::allowgroup {

	fragment { "sshd_config_AllowGroups-${name}":
	  path => "/etc/ssh",
	  target => "sshd_config",
	  content => "AllowGroups ${name}\n",
	}

}

