class jumpstart {
	#http://hintshop.ludvig.co.nz/show/solaris-jumpstart-linux-server/
	package {
		"rarpd": ensure => installed;
		"bootparamd": ensure => installed;
	}

}
