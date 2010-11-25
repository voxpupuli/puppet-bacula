# this was built on centos, please don't sue me if it does not work on other distros

class yum::mirror {
	include apache 

	$storage = '/var/www/html'
	$dirs = [
		"${storage}/centos",
	]

 package { 
		"createrepo": ensure => present,
  }

	centos { [5.5, 4.8]:
		require => Package['createrepo']
	}

}

define centos () { # syncs the os and updates for the given revistion, i386 and x86_64 only currently
	$rev = $name
	$mirror = "mirrors.kernel.org"
	$dirs = [
		"${storage}/centos/${rev}",
		"${storage}/centos/${rev}/os",
		"${storage}/centos/${rev}/updates",
	]

	file { $dirs: ensure => directory, recurse => true, owner => root, group => root, mode => 755; }
	
	cron {
		"yum mirror os sync $rev": 
			user => root,
			command => "/usr/bin/rsync -aq --del --include '/i386/' --include '/x86_64/' --exclude '/*' mirrors.kernel.org::centos/${rev}/os/ /var/www/html/centos/${rev}/os/",
			minute => 10,
			hour => 1,
			weekday => 0;
		"yum mirror updates sync $rev": 
			user => root,
			command => "/usr/bin/rsync -aq --del --include '/i386/' --include '/x86_64/' --exclude '/*' mirrors.kernel.org::centos/${rev}/updates/ /var/www/html/centos/${rev}/updates/",
			minute => 10,
			hour => 2,
			weekday => 0;
	}

}

