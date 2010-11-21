class php::mysql{
  require php
	include php::params
  package{"$php::params::php_mysql_package":
    ensure => present,
  }
}
