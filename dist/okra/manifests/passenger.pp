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
  include apache
  include passenger

  apache::vhost { "okra.puppetlabs.lan":
    port => 443,
    ssl  => true,
    docroot => "${okra::params::basedir}/public",
    template => 'okra/okra-passenger.conf.erb',
    require  => Class["okra::package"],
  }
}
