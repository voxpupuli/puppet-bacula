class munin::nginx {
  include munin::params
  include munin

  munin::plugin { [ 'nginx_status', 'nginx_request']: }

}
