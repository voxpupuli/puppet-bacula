# Class: nginx
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
class nginx {

  include nginx::params

  if ! $nginx::params::package {
    fail( "No nginx possible on ${hostname}" )
  }

  if defined(Class['munin'])  { include munin::nginx }

}
