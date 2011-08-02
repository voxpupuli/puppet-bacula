# Class: okra::passenger
#
# Deploys okra on apache and passenger
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class okra::passenger {
  include okra
  include okra::params
  include apache

  $user  = $okra::params::user
  $group = $okra::params::group

  package { "libapache2-mod-passenger":
    ensure => present, 
  }

  apache::vhost { "okra.puppetlabs.lan":
    port => 443,
    ssl  => true,
    docroot => "${okra::params::basedir}/public",
    template => 'okra/okra-passenger.conf.erb',
    require  => Class["okra::package"],
  }
}
