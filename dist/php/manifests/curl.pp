class php::curl {
  include php::params
  package {"$php::params::curl_package": ensure => present, notify => Service[httpd] }

}
