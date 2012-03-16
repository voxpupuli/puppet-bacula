class munin::bind {

  include munin::params
  include munin::extra
  include bind::params

  @munin::plugin     { "bind9_rndc": }
  @munin::pluginconf { "bind9_rndc":
      confname => 'bind9_rndc',
      confs => {
        "user"           => $bind::params::bind_user,
        "env.rndc"       => "/usr/sbin/rndc",
        "env.querystats" => $bind::params::bind_stats,
      }
  }

}
