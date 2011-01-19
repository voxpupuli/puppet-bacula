class puppetlabs::pluto {
  include puppetlabs::lan	

	ssh::allowgroup { "developers": }

	file {
		"/opt/enterprise": 
		  owner => root,
			group => developers,
			mode => 775,
			recurse => true;
	}

}
