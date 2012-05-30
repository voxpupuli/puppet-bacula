# Class: bacula
#
# A class to configured a Bacula File Daemon for use with the Bacula backup system.  SEE: http://www.bacula.org/
#
# Parameters:
#   * port - the port that this daemon will listen on
#   * file_retention - how long to keep files information around
#   * job_retention - how long to keep information about jobs around
#   * autoprune - weather to auto-truncate old volumes
#   * monitor - should we monitor the services ( ie: nagios )
#
# Actions:
#   * Installs packages for the bacula-fd
#   * Configures the file daemon to accept connections from the director
#
# Requires:
#
# Sample Usage:
#   include bacula
#
class bacula (
    $port           = $bacula::params::port,
    $file_retention = $bacula::params::file_retention,
    $job_retention  = $bacula::params::job_retention,
    $autoprune      = $bacula::params::autoprune,
    $monitor        = $bacula::params::monitor,
  ) inherits bacula::params {

  include bacula::params

  $bacula_director   = $bacula::params::bacula_director
  $bacula_is_storage = $bacula::params::bacula_is_storage
  $listen_address    = $bacula::params::listen_address
  $working_directory = $bacula::params::working_directory
  $pid_directory     = $bacula::params::pid_directory
  $bacula_password   = $bacula::params::bacula_password

  if $bacula_is_storage == "yes" { include bacula::storage }
  if $monitor           == true  { include bacula::client::monitor }

  include bacula::common

  @@concat::fragment {
    "bacula-client-$hostname":
      target  => '/etc/bacula/conf.d/client.conf',
      content => template("bacula/client.conf.erb"),
      tag     => "bacula-${bacula_director}";
  }

  bacula::job {
    "${fqdn}-common":
      fileset => "Common",
  }

  # realize the firewall rules exported from the director
  if defined (Class["firewall"]) {
    firewall {
      '0175-INPUT allow tcp 9102':
        proto  => 'tcp',
        dport  => '9102',
        source => "$bacula_director",
        jump   => 'ACCEPT',
    }
  }

}

