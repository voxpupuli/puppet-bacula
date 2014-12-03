# Class: bacula::virtual
#
# This class contains virtual resources shared between the bacula::director
# and bacula::storage classes.
#
class bacula::virtual(
  $director_packages = $bacula::params::bacula_director_packages,
  $storage_packages  = $bacula::params::bacula_storage_packages,
) inherits bacula::params {
  @package { $director_packages:
    ensure => present
  }

  @package { $storage_packages:
    ensure => present
  }
}
