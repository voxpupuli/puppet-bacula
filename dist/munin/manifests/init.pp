# Class: munin
#
# This class installs and configures Munin
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
class munin (
    $munin_server
  ) {
  include munin::params

  package {
    $munin::params::munin_base_packages:
      ensure   => present,
      provider => $kernel ? {
        Darwin  => macports,
        default => undef,
      }
  }

  file { $munin::params::node_config:
    content => template('munin/munin-node.conf.erb'),
    ensure  => present,
    notify  => Service[$munin::params::node_service],
    require => Package[$munin::params::munin_base_packages],
  }

  service { $munin::params::node_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => [
      File[$munin::params::node_config],
      Package[$munin::params::munin_base_packages]
    ],
  }

  @@file { "/etc/munin/munin-conf.d/$fqdn":
    content => template('munin/munin-host.conf.erb'),
    ensure  => present,
    tag     => 'munin_host',
  }

  @firewall {
    '0150-INPUT ACCEPT 4949':
      jump   => 'ACCEPT',
      dport  => "4949",
      proto  => 'tcp',
      source => $munin_server,
  }
}
