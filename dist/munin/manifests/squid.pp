# Class: munin::squid
#
# This class installs and configures Munin for squid
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The munin::params class
#
# Sample Usage:
#
class munin::squid {
  include munin::params
  include munin

  munin::plugin { [ 'squid_cache', 'squid_objectsize', 'squid_requests', 'squid_traffic']: }
}
