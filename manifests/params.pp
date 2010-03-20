# Class: bacula::params
#
# This class contains the Bacula module parameters
#
# Parameters:
#
#
# Actions:
#
# Requires:
#   - On CentOS the epel module
#
# Sample Usage:
#
class bacula::params {
  $bacula_server = "bast.reductivelabs.com"
}
