# Define: bacula::director::pool
#
# This define adds a pool to the bacula director configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define bacula::director::pool (
    $type        = 'Backup',
    $recycle     = 'Yes',
    $autoprune   = 'Yes',
    $volret      = '4 months', # Volume Retention
    $maxvoljobs  = '1',
    $maxvolbytes = '1000000000',
    $maxvols     = '30',
    $label       = ''

  ) {

  concat::fragment {
    "bacula-director-pool-$name":
      target  => '/etc/bacula/conf.d/pools.conf',
      content => template("bacula/pool.conf.erb");
  }

}

