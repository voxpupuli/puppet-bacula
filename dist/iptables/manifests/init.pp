class iptables {
	file { 
		"/etc/puppet/iptables":
			ensure => directory,
			owner => root,
			group => root,
			mode => 755;
		"/etc/puppet/iptables/pre.iptables":
			mode => 644,
			owner => root,
			group => root,
			source => "puppet:///modules/iptables/pre.iptables";
	}
}

