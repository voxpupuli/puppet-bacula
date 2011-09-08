class php::pear {
  include php::params
  package { "$php::params::pear_packge": ensure => installed; }
}
