# Define: bacula::director::pool
#
# This define adds a pool to the bacula director configuration in the conf.d
# method.  This resources is intended to be used from bacula::storage as a way
# to export the pool resources to the director.
#
# @param pooltype    - Bacula pool configuration option "Pool Type"
# @param recycle     - Bacula pool configuration option "Recycle"
# @param autoprune   - Bacula pool configuration option "AutoPrune"
# @param volret      - Bacula pool configuration option "Volume Retention"
# @param maxvoljobs  - Bacula pool configuration option "Maximum Volume Jobs"
# @param maxvolbytes - Bacula pool configuration option "Maximum Volume Bytes"
# @param purgeaction - Bacula pool configuration option "Action On Purge"
# @param label       - Bacula pool configuration option "Label Format"
#
# @example
#   bacula::director::pool {
#     "PuppetLabsPool-Full":
#       volret      => "2 months",
#       maxvolbytes => '2000000000',
#       maxvoljobs  => '10',
#       maxvols     => "20",
#       label       => "Full-";
#   }
#
define bacula::director::pool (
  Optional[String] $volret         = undef,
  Optional[String] $maxvoljobs     = undef, # FIXME: Change type to Integer
  Optional[String] $maxvolbytes    = undef, # FIXME: Change type to Integer
  Optional[String] $maxvols        = undef, # FIXME: Change type to Integer
  Optional[String] $label          = undef,
  Optional[String] $voluseduration = undef,
  String           $storage        = $bacula::director::storage,
  String           $pooltype       = 'Backup',
  String           $recycle        = 'Yes', # FIXME: Change type to Boolean
  String           $autoprune      = 'Yes', # FIXME: Change type to Boolean
  String           $purgeaction    = 'Truncate',
  Optional[String] $next_pool      = undef,
  String           $conf_dir       = $::bacula::conf_dir
) {

  concat::fragment { "bacula-director-pool-${name}":
    target  => "${conf_dir}/conf.d/pools.conf",
    content => template('bacula/bacula-dir-pool.erb');
  }
}
