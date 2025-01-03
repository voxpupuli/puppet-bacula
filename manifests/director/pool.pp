# @summary Configure a Bacula Director Pool
#
# This define adds a pool to the bacula director configuration in the conf.d
# method.  This resources is intended to be used from bacula::storage as a way
# to export the pool resources to the director.
#
# @param volret         Bacula pool configuration option "Volume Retention"
# @param maxvoljobs     Bacula pool configuration option "Maximum Volume Jobs"
# @param maxvolbytes    Bacula pool configuration option "Maximum Volume Bytes"
# @param maxvols        Bacula pool configuration option "Maximum Volumes"
# @param label          Bacula pool configuration option "Label Format"
# @param voluseduration Bacula pool configuration option "Volume Use Duration"
# @param storage        Bacula pool configuration option "Storage"
# @param pooltype       Bacula pool configuration option "Pool Type"
# @param recycle        Bacula pool configuration option "Recycle"
# @param autoprune      Bacula pool configuration option "AutoPrune"
# @param purgeaction    Bacula pool configuration option "Action On Purge"
# @param next_pool      Bacula pool configuration option "Next Pool"
# @param conf_dir       The path to the bacula configuration directory
#
# @example
#   bacula::director::pool {
#     "PuppetLabsPool-Full":
#       volret      => "2 months",
#       maxvolbytes => 2000000000,
#       maxvoljobs  => 10,
#       maxvols     => 20,
#       label       => "Full-";
#   }
#
define bacula::director::pool (
  Optional[Bacula::Time]                  $volret         = undef,
  Optional[Variant[String[1],Integer[1]]] $maxvoljobs     = undef, # FIXME: Remove String
  Optional[Bacula::Size]                  $maxvolbytes    = undef,
  Optional[Variant[String[1],Integer[1]]] $maxvols        = undef, # FIXME: Remove String
  Optional[String[1]]                     $label          = undef,
  Optional[Bacula::Time]                  $voluseduration = undef,
  String[1]                               $storage        = $bacula::director::storage,
  String[1]                               $pooltype       = 'Backup',
  Bacula::Yesno                           $recycle        = true,
  Bacula::Yesno                           $autoprune      = true,
  String[1]                               $purgeaction    = 'Truncate',
  Optional[String[1]]                     $next_pool      = undef,
  Stdlib::Absolutepath                    $conf_dir       = $bacula::conf_dir,
) {
  $epp_pool_variables = {
    name           => $name,
    pooltype       => $pooltype,
    recycle        => $recycle,
    autoprune      => $autoprune,
    volret         => $volret,
    voluseduration => $voluseduration,
    label          => $label,
    maxvols        => $maxvols,
    maxvoljobs     => $maxvoljobs,
    maxvolbytes    => $maxvolbytes,
    storage        => $storage,
    purgeaction    => $purgeaction,
    next_pool      => $next_pool,
  }

  concat::fragment { "bacula-director-pool-${name}":
    target  => "${conf_dir}/conf.d/pools.conf",
    content => epp('bacula/bacula-dir-pool.epp', $epp_pool_variables),
  }
}
