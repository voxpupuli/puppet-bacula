# Class: bacula::virtual
#
# This class contains virtual resources shared between the bacula::director
# and bacula::storage classes.
#
class bacula::virtual(
  $director_packages = $bacula::params::bacula_director_packages,
  $storage_packages  = $bacula::params::bacula_storage_packages,
) inherits bacula::params {
  # Get the union of all the packages so we prevent having duplicate packages,
  # which is exactly the reason for having a virtual package resource.
  $packages = union($director_packages, $storage_packages)
  @package { $packages:
    ensure => present
  }
}
