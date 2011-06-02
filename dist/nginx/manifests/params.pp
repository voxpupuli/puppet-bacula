


# Class: nginx::params
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nginx::params {

  case $operatingsystem {
    'debian',
    'ubuntu': {
        $package    = 'nginx'
        $service    = 'nginx'
        $hasrestart = true
        $hasstatus  = true
        $etcdir     = '/etc/nginx'
        $vdir       = "${etcdir}/sites-enabled"
      }
    default: {
        warning( "Sorry, nginx module isn't built for ${operatingsystem} yet." )
    }
  }
}
