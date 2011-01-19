class puppetlabs::zachdev {
  include ssh::server
  include virtual::users 
  include sudo
	include packages

	ssh::allowgroup { "sysadmin": }
	ssh::allowgroup { "prosvc":
		chroot => true;	
	}

	sudo::allowgroup { "developers": }

  #Account::User <| tag == 'allstaff' |>
  #Group <| tag == 'allstaff' |>

	#sqldb { "patchwork":
	#	ensure => present,
	#	owner => patchwork;
	#}

}
