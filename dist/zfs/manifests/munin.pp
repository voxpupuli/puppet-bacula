class zfs::munin {

  include munin::params

  # install the files, then use them.
  file{ "${munin::params::plugin_source}/zfs":
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///module/zfs/muninplugins/',
  }

	$plugins = [  'zfs-filesystem-graph',
                'zfs-statistics-for-freebsd',
                'zfs-stats-for-freebsd-arc-efficiency',
                'zfs-stats-for-freebsd-arc-utilization',
                'zfs-stats-for-freebsd-cache-hits-by-cache-list',
                'zfs-stats-for-freebsd-cache-hits-by-data-type',
                'zfs-stats-for-freebsd-dmu-prefetch',
                'zfs_arc_cache_hits_by_cache_list',
                'zfs_arc_cache_hits_by_data_type',
                'zfs_arc_efficiency',
                'zfs_arc_utilization',
                'zfs_dmu_prefetch',
                'zlist',
                'zpool_iostat' ]

  munin::pluginer{ $plugins: ,
    pluginpath => "${munin::params::plugin_source}/zfs",
    require    => File["${munin::params::plugin_source}/zfs"],
  }

}
