class php::params {
	case $operatingsystem {
			"ubuntu": {
				$php_package="php5"
				$php_mysql_package="php5-mysql"
			}
			"centos": {
				$php_package="php"
				$php_mysql_package="php-mysql"
			}
	}
}
