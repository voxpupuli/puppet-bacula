class munin::freebsd {

  include munin::params

  # Not using:
    #' dev_cpu_',
    #' if_',
    #' if_errcoll_',
    #' ifx_concurrent_sessions_',
    #' ipmi_sensor_',
    #' smart_',

  include munin::plugins

  # Installed from puppet.
  $plugins_freebsd    = [  'kmemsum', ]

  munin::plugins::install{ 'freebsd': }

  munin::plugin{ $plugins_freebsd:
    pluginpath => "${munin::params::plugin_source}/freebsd",
    require    => Munin::Plugins::Install['freebsd'],
  }

}
