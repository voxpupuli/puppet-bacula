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
    $port           = '9102',
    $file_retention = "45 days",
    $job_retention  = "6 months",
    $autoprune      = "yes",
    $monitor        = true,
  ){

  include bacula::params

  $bacula_director   = hiera('bacula_director')
  $bacula_password   = $::bacula_password
  $bacula_is_storage = hiera('bacula_is_storage')
  $listen_address    = hiera('bacula_client_listen')
  $working_directory = $bacula::params::working_directory
  $pid_directory     = $bacula::params::pid_directory


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

