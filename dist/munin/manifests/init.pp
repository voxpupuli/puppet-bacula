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
class munin {

  include munin::params

  $munin_server       = hiera("munin_server")
  $munin_node_address = hiera('munin_node_address',$ipaddress)
  $log_file           = $munin::params::log_file
  $pid_file           = $munin::params::pid_file
  $group              = $munin::params::group

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

  file {
    $munin::params::plugins_conf:
      content => template('munin/munin-plugins.conf.erb'),
      ensure  => present,
      notify  => Service[$munin::params::node_service],
      require => Package[$munin::params::munin_base_packages];
    "${munin::params::plugins_conf}.sample":
      ensure => absent;
  }

  # Bold move, manage the plugindest dir, where the symlinks live, and
  # remove the ones we don't want, a la #12701
  file { $munin::params::plugin_dest:
    ensure  => directory,
    owner   => 'root',
    group   => $kernel ? {
      'freebsd' => 'wheel',
      default   => 'root',
    },
    mode    => '0755',
    recurse => true,
#    purge   => true, # Leave this out, then we can remove it later.
## See https://projects.puppetlabs.com/issues/12701 for this.
    notify  => Service[$munin::params::node_service],
    require => Package[$munin::params::munin_base_packages],
  }

  # Yes, this is somewhat dirty, but there isn't a Puppet function
  # directly for getting the directory name.
  $logdir = inline_template( "<%= File.dirname( log_file ) %>" )
  $piddir = inline_template( "<%= File.dirname( pid_file ) %>" )

  file {
    $logdir:
      ensure  => directory,
      owner   => 'munin',
      mode    => '0750',
      require => Package[$munin::params::munin_base_packages];
    $piddir:
      ensure  => directory,
      owner   => 'munin',
      group   => $group,
      mode    => '0770',
      require => Package[$munin::params::munin_base_packages];
  }

  # This is kinda dirty, but it does make a bunch of crappy plugins
  # "just work" without having to fix things in munin. See the vile
  # use of "$MUNIN_PLUGSTSTE" and the likes. (Some are even more
  # obscured in the CPAN libraries.
  if $kernel == "FreeBSD" {
    file { '/var/munin/plugin-state':
      ensure  => link,
      target  => $piddir,
      require => File[$piddir];
    }
  }

  service { $munin::params::node_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => [
      File[$munin::params::node_config],
      Package[$munin::params::munin_base_packages],
      File[$logdir],
      File[$piddir]
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

  # put this here, not that ordering matters, but I'd like it to.
  include munin::automagical
  include munin::interfaces
  # Class['munin::automagical'] -> Class['munin']
  Class['munin'] -> Class['munin::automagical']

  Munin::Plugin <||>
  Munin::Pluginconf <||>

}
