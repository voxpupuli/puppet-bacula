class munin::plugins {

  # Not using:
    #' dev_cpu_',
    #' if_',
    #' if_errcoll_',
    #' ifx_concurrent_sessions_',
    #' ipmi_sensor_',
    #' smart_',

	$plugins = [ 'cpu',
    'df', 'df_inode', 'env', 'id',
    'iostat', 'load', 'memory', 'netstat',
    'open_files', 'postfix_mailqueue',
    'postfix_mailstats', 'postfix_mailvolume',
    'processes',
    'swap', 'systat', 'uptime',
    'users', 'vmstat']

  @munin::plugin{ $plugins: }

  if $::is_virtual == false {
    @munin::plugin{ 'hddtemp_smartctl': }
  }

}

