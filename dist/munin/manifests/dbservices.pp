# Class: munin::dbservices
#
# This class installs and configures Munin for databases
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
class munin::dbservices {
  include munin::params
  include munin

  munin::plugin { [ 'mysql_', 'mysql_bytes', 'mysql_innodb', 'mysql_queries', 'mysql_threads', 'mysql_slowqueries' ]: }

}
