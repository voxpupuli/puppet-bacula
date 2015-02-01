# Define: bacula::director::pool
#
# This define adds a pool to the bacula director configuration in the conf.d
# method.  This resources is intended to be used from bacula::storage as a way
# to export the pool resources to the director.
#
# Parameters:
# *  pooltype    - Bacula pool configuration option "Pool Type"
# *  recycle     - Bacula pool configuration option "Recycle"
# *  autoprune   - Bacula pool configuration option "AutoPrune"
# *  volret      - Bacula pool configuration option "Volume Retention"
# *  maxvoljobs  - Bacula pool configuration option "Maximum Volume Jobs"
# *  maxvolbytes - Bacula pool configuration option "Maximum Volume Bytes"
# *  purgeaction - Bacula pool configuration option "Action On Purge"
# *  label       - Bacula pool configuration option "Label Format"
#
# Actions:
#
# Requires:
#
# Sample Usage:
# bacula::director::pool {
#   "PuppetLabsPool-Full":
#     volret      => "2 months",
#     maxvolbytes => '2000000000',
#     maxvoljobs  => '10',
#     maxvols     => "20",
#     label       => "Full-";
# }
#
define bacula::director::pool (
  $volret,
  $maxvoljobs,
  $maxvolbytes,
  $maxvols,
  $label,
  $storage     = $::fqdn,
  $pooltype    = 'Backup',
  $recycle     = 'Yes',
  $autoprune   = 'Yes',
  $purgeaction = 'Truncate',
  $conf_dir    = $bacula::params::conf_dir, # Overridden at realize
) {

  include bacula::params

  concat::fragment { "bacula-director-pool-${name}":
    target  => "${conf_dir}/conf.d/pools.conf",
    content => template('bacula/pool.conf.erb');
  }
}
