class puppetlabs::app01 {

	include patchwork
#	include pkgs::admin
#	include django
#  
#	$mysql_root_pw = 'aksjdhaskjhasdKJHASkjhasd'
#	include mysql::server
#
#  apache::vhost {'app01.puppetlabs.lan':
#    port => 80,
#    docroot => '/var/www',
#    ssl => false,
#    priority => 10,
#    template => 'puppetlabs/patchwork.conf.erb',
#  }
#	$www_data_passwd = 'aslkdjasdGSDMbmsbdak'
#	$nobody_passwd = 'alskdjalskdjaloqiueoqiwmnzbxcvmnxzcbv'
#
#	database_user{'www-data@localhost':
#		ensure => present,
#		password_hash => mysql_password($www_data_passwd)
#	}
#
#  mysql::db{"patchwork":
#    db_user => 'patchwork',
#    db_pw => 'kjasdjajsdb',
#  }
#
#	package { "python-mysqldb": ensure => installed; }
#	package { "python-django-registration": ensure => installed; }
#	
#	file { "/var/www/apps/local_settings.py":
#		owner => root,
#		group => www-data,
#		mode => 640,
#		source => "puppet:///modules/patchwork/local_settings.py";
#	}

}
