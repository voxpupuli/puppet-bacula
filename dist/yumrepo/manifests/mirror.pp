class yumrepo::mirror {
  include apache

	$mirror = "mirrors.kernel.org"
	$rev = "5.5"
	$arch = "i386"

  package { 
		"createrepo": ensure => present,
  }

	$dirs = [
		"/var/www/html/centos",
		"/var/www/html/centos/${rev}",
		"/var/www/html/centos/${rev}/os",
		"/var/www/html/centos/${rev}/updates",
		"/var/www/html/centos/${rev}/os/${arch}",
		"/var/www/html/centos/${rev}/updates/${arch}",
	]

	file { $dirs: ensure => directory, owner => root, group => root, mode => 755; }

	exec {
		"/usr/bin/createrepo /var/www/html/centos/$rev/os/${arch}":
			creates => "/var/www/html/centos/${rev}/os/${arch}/repodata";
	}

	cron {
		"yum mirror sync": 
			user => root,
			command => "/usr/bin/rsync -aq --del rsync://${mirror}/centos/${rev}/updates/${arch}/ --exclude=debug/ /var/www/html/centos/${rev}/updates/${arch}/",
			minute => 10,
			hour => 1,
			weekday => 0;
	}

# initial
#/usr/bin/rsync -avrt rsync://mirrors.kernel.org/centos/5.5/updates/i386 --exclude=debug/ /var/www/html/centos/5.5/updates/

}
