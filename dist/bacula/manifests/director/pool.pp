define bacula::director::pool (
    $type        = "Backup',
    $recycle     = "Yes",
    $autoprune   = "Yes",
    $volret      = "4 months" # Volume Retention
    $maxvoljobs  = '1',
    $maxvolbytes = '1000000000',
    $maxvols     = '30'
    $label       = ''

  ) {

  concat::fragment {
    "bacula-director-pool-$name":
      target => '/etc/bacula/conf.d/pools.conf'
      concat => tempalte("bacula/pool.conf.erb");
  }

}

