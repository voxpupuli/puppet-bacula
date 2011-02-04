class puppetlabs::pluto {
  include puppetlabs::lan	

	ssh::allowgroup { "developers": }
	ssh::allowgroup { "prosvc": }

	# Customer Groups
  Account::User <| group == vmware |>
  Group <| title == vmware |>
  ssh::allowgroup { "vmware": chroot => true; }
	
	package { "cryptsetup": ensure => installed; }

	exec { "/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4":
		creates => '/var/chroot.key';
	}
	
	file { 
		"/var/chroot.key": mode => 0400, require => Exec["/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4"];
	}

	file {
		"/opt/enterprise": 
		  owner => root,
			group => developers,
			mode => 775,
			recurse => true;
	}

}
