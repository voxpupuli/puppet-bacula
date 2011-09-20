class kickstart::params(
  $docroot  = 'UNSET',
  $wwwuser  = 'UNSET',
  $wwwgroup = 'UNSET'
) {

  # Validate and set default values
  case $operatingsystem {
    'fedora', 'centos', 'redhat': {
      $default_docroot  = "/var/www/html"
      $default_wwwuser  = "apache"
      $default_wwwgroup = "apache"
    }
    'ubuntu', 'debian': {
      $default_docroot  = "/var/www"
      $default_wwwuser  = "www-data"
      $default_wwwgroup = "www-data"
    }
    default: {
      fail("Module kickstart does not support operatingsystem $operatingsystem")
    }
  }

  if $docroot  == 'UNSET' { $ks_root = "${default_docroot}/ks" } else { $ks_root = "${docroot}/ks" }
  if $wwwuser  == 'UNSET' { $ks_user = $default_wwwuser        } else { $ks_user = $wwwuser }
  if $wwwgroup == 'UNSET' { $ks_group = $default_wwwgroup      } else { $ks_group = $wwwgroup }
}
