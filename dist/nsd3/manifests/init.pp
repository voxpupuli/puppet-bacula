# Class: nsd3
#
#   nsd3 name server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nsd3 {
  $module = "myclass"
  notify { "FIXME: ${module} unimplemented": }
  # statements

  case $operatingsystem {
    'debian': {
      include nsd3::server::debian
    }
    default: {
      warning( "Sorry, nsd3 isn't supported on $operatingsystem/$hostname" )
    }
  }

}
