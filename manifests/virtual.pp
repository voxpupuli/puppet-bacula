# Class: bacula::virtual
#
# This class contains virtual resources shared between the bacula::director and
# bacula::storage classes.  This allows the director and storate roles to be
# installed on either seperate machines, or the same machine.  On some
# platforms, the director package and storate package are the same, while on
# other platforms there are seperate packages for each.
#
class bacula::virtual {
  # Get the union of all the packages so we prevent having duplicate packages,
  # which is exactly the reason for having a virtual package resource.

  $director_packages = lookup('bacula::director::packages')
  $storage_packages  = lookup('bacula::storage::packages')
  $db_type = lookup('bacula::director::db_type')
  $packages          = ($director_packages + $storage_packages).unique

  $packages.each |$p| {
    $package_name = inline_epp($p, {
      'db_type' => $db_type
    })

    @package { $package_name:
      ensure => present,
    }
  }

}
