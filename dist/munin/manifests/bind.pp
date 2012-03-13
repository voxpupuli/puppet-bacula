munin::bind {

  include munin::params
  include munin::extra
  include munin
  include bind::params

  munin::plugin     { "bind_rndc": }
  munin::pluginconf { "bind_rndc":
      confname => 'bind_rndc',
      confs => {
        "env.rndc"       => "/usr/sbin/rndc",
        "env.querystats" => $bind::params::bind_stats,
      }
  }

}
