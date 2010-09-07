# Class: solr
#
# This class installs and configures solr
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The solr::params class
#
# Sample Usage:
#
class solr {
  include solr::params

  package { 'solr-jetty':
    ensure => present,
  }

  service { 'solr':
    ensure => running,
    enable     => true,
    hasrestart => true,
    require => Package['solr-jetty'],
  }

}
