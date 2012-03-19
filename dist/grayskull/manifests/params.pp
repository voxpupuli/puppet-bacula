class grayskull::params {

  case $operatingsystem {
    'debian': {
      $wwwuser    = 'www-data'
      $wwwgroup   = 'www-data'
      $jdkpkg     = 'openjdk-6-jdk'
    }
    'freebsd': {
      $wwwuser    = 'www'
      $wwwgroup   = 'www'
      $jdkpkg     = 'java/openjdk6'
    }
    default: {
      warning( "Sorry, grayskull module isn't built for ${operatingsystem} yet." )
    }
  }

}
