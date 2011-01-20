class puppetlabs::pluto {
  include puppetlabs::lan	

	ssh::allowgroup { "developers": }
	ssh::allowgroup { "prosvc": }

	file {
		"/opt/enterprise": 
		  owner => root,
			group => developers,
			mode => 775,
			recurse => true;
	}

}
