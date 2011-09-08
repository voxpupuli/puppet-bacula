class php::curl {

  package {'php5-curl': ensure => present, notify => Service[httpd] }

}
