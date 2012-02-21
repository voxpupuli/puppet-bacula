class munin::freebsd {

  include munin::params

  # Not using:
    #' dev_cpu_',
    #' if_',
    #' if_errcoll_',
    #' ifx_concurrent_sessions_',
    #' ipmi_sensor_',
    #' smart_',

  # Installed from ports/pkg munin-node/common.
	$plugins_ports_base = [ 'cpu', 'cupsys_pages',
                          'df', 'df_inode', 'env',
                          'hddtemp_smartctl', 'id',
                          'iostat', 'load', 'memory', 'netstat',
                          'open_files', 'postfix_mailqueue',
                          'postfix_mailstats', 'postfix_mailvolume',
                          'processes',
                          'swap', 'systat', 'uptime',
                          'users', 'vmstat']

  munin::plugin{ $plugins_ports_base: }


  # Installed from puppet.
  $plugins_freebsd    = [  'kmemsum', ]

  munin::plugins::install{ 'freebsd': }

  munin::plugin{ $plugins_freebsd:
    pluginpath => "${munin::params::plugin_source}/freebsd",
    require    => Munin::Plugins::Install['freebsd'],
  }

}
