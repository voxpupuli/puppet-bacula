# Define: nginx::vhost::redirect.
#
#   nginx vhost. redirects, For bouncing web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::vhost::redirect (
  $dest,
  $port       = '80',
  $priority   = '10',
  $template   = 'nginx/vhost-redirect.conf.erb',
  $servername = '',
  $status     = 'permanent',
  $magic      = ''
  ) {

  include nginx

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  file {
    "${nginx::params::vdir}/${priority}-${name}":
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
