# Parameterised Class: nginx::server::cache-vhost
#
#   Ngninx standard cache for offloading connections. Saves the
#   backend app server having to do it.
#
# Parameters:
#   upstream_server/port are the apache/unicorn thing behind the
#   scenes.
#
#   port is the port to listen on, on all interfaces, so don't use 80
#   unless you want it to be the prime site.
#
#   magic is just if you want to include a chunk of other options as a
#   text blob.
#
# Actions:
#
# Requires:
#
# include nginx::server
#
# Sample Usage:
#
#  class { 'nginx::cache': port => 80 , upstream_port 8080 }
#
class nginx::cache (
  $port            = '82',
  $priority        = '10',
  $template        = 'nginx/vhost-caching.conf.erb',
  $upstream_server = 'localhost',
  $upstream_port   = '80',
  $magic           = ''
  ) {

  # this pulls in params too, to check it works and get paths.
  include nginx

  file {
    "${nginx::params::vdir}/${priority}-${upstream_server}_caching":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['nginx'],
      notify  => Service['nginx'],
  }


  # liberally borrowed from apache module.
  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
    @firewall {
      "0100-INPUT ACCEPT $port":
        jump  => 'ACCEPT',
        dport => "$port",
        proto => 'tcp'
    }
  }

}
# EOF
