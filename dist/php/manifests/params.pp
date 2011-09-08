class php::params {
  case $operatingsystem {
      "ubuntu","debian": {
        $php_package       = "php5"
        $php_mysql_package = "php5-mysql"
        $curl_package      = "php5-curl"
        $pear_package      = "php-pear"
      }
      "centos": {
        $php_package       = "php"
        $php_mysql_package = "php-mysql"
      }
  }
}
