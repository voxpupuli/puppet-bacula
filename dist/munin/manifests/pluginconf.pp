# $confname is the name of the configuration to put in the file
# $confs is the hash of env.plugin entries to put

define munin::pluginconf ($confs,$confname){

  include munin::params

  file { "${munin::params::confdir}/plugin-conf.d/${name}":
    content => template("munin/plugin.conf.erb"),
    notify  => Service[$munin::params::node_service],
  }

}

