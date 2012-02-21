class munin::nginx {
  include munin::params
  include munin

  include nginx::status
  package { "libwww-perl": ensure => installed; }
  munin::plugin { [ 'nginx_status', 'nginx_request']: }
  munin::pluginconf { "nginx":
      confname => 'nginx*',
      envs => { "url" => "http://127.0.0.1/nginx_status" }
  }
}
