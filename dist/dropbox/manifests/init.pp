class dropbox {

	#file {
	#	"/etc/init.d/dropbox": owner => root, group => root, mode => 755,
	#		source => "puppet:///modules/dropbox/dropboxd";
	#}

	#service { "dropboxd": ensure => running, enable => true, hasstatus => true, 
	#	require => File["/etc/init.d/dropbox"];
	#}

}

