define ssh::allowgroup {

	concat::fragment { "sshd_config_AllowGroups-${name}":
	  target => "/etc/ssh/sshd_config",
	  content => "AllowGroups ${name}\n",
	}

}

