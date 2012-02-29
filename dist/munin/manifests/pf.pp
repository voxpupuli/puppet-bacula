class munin::pf {

  include munin::params

  # install the files, then use them.
  file{ "${munin::params::plugin_source}/pf":
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 0, # wheel or root.
    mode    => '0755',
    source  => 'puppet:///modules/munin/pf',
  }

  $plugins = [  'pf', 'pf_bytes', 'pf_packets', 'pf_searches', 'pf_states' ]

  munin::plugin{ $plugins: ,
    pluginpath => "${munin::params::plugin_source}/pf",
    require    => File["${munin::params::plugin_source}/pf"],
  }

}
