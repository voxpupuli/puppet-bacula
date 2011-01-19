class puppetlabs::app01 {
	include puppetlabs::lan
	include patchwork
	
	ssh::allowgroup { "developers": }

}
