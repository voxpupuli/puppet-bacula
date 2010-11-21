class approx {
	package { "approx": ensure => installed; }

	file { 
		"/etc/approx/approx.conf": owner => root, group => root, mode => 644, 
			source => "puppet:///modules/approx/approx.conf";
	}

	cron { "approx excercise":
		user => "root",
		hour => "0",
		minute => "5",
		command => "/usr/bin/apt-get update && /usr/bin/apt-get -dy upgrade; /usr/bin/apt-get clean";
	}

	iptables { "approx":
		proto => "tcp",
		dport => "9999",
		jump => "ACCEPT"
	}

}

