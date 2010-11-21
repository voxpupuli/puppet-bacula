class yum::mirror {
	include apache 

	$storage = '/var/www/html'
	$dirs = [
		"${storage}/centos",
	]
 
 package { 
		"createrepo": ensure => present,
  }

	yummirrorversion { [5.5, 4.8] :
		require => Package['createrepo']
	}
}

define yummirrorversion () {
	# setup the version
	$rev = $name
	$mirror = "mirrors.kernel.org"
	$dirs = [
		"${storage}/centos/${rev}",
		"${storage}/centos/${rev}/os",
		"${storage}/centos/${rev}/updates",
	]
	
	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }
	
	yummirrorarch { 
		"${rev}_x86_64":
			storage => $storage,
			rev			=> $rev,
			mirror	=> $mirror,
			arch		=> "x86_64";
		"${rev}_i386":
			storage => $storage,
			rev			=> $rev,
			mirror	=> $mirror,
			arch		=> "i386";
	}

}

define yummirrorarch ($storage,$rev,$mirror,$arch) {

	$dirs = [
		"${storage}/centos/${rev}/os/${arch}",
		"${storage}/centos/${rev}/updates/${arch}",
	]

	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }

	cron {
		"yum mirror updates sync $arch $rev": 
			user => root,
			command => "/usr/bin/rsync -aq --del rsync://${mirror}/centos/${rev}/updates/${arch}/ --exclude=debug/ ${storage}/centos/${rev}/updates/${arch}/",
			minute => 10,
			hour => 1,
			weekday => 0;
		"yum mirror os sync $arch $rev": 
			user => root,
			command => "/usr/bin/rsync -aq --del rsync://${mirror}/centos/${rev}/os/${arch}/ --exclude=debug/ ${storage}/centos/${rev}/updates/${arch}/",
			minute => 10,
			hour => 3,
			weekday => 0;
	}

}

