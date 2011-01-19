class puppetlabs::apu {
	include puppetlabs::www, puppetlabs::docs
	ssh::allowgroup { "www-data": }
}
