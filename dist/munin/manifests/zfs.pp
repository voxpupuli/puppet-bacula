class munin::zfs {

  include munin::params

  munin::plugins::install{ zfs: }

  $plugins = [  'zfs-stats-for-freebsd-arc-efficiency',
                # 'zfs-stats-for-freebsd-arc-utilization',
                'zfs-stats-for-freebsd-cache-hits-by-cache-list',
                'zfs-stats-for-freebsd-cache-hits-by-data-type',
                'zfs-stats-for-freebsd-dmu-prefetch',
                'zlist',
	              # 'zfs-fs',  # needs linking to fs.
                'zpool_iostat' ]

  munin::plugin{ $plugins: ,
    pluginpath => "${munin::params::plugin_source}/zfs",
    require    => Munin::Plugins::Install['zfs'],
  }

  # On freebsd requires gawk
  if $::operatingsystem == 'freebsd' {
    package{ 'lang/gawk': ensure => installed,}
  }

}
