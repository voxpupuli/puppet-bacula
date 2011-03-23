# Define: apache::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a given location
#
# Parameters:
#   $port:
#       Which port to list on
#   $dest:
#       Where to redirect to
#
# Actions:
#   Installs apache and creates a vhost
#
# Requires:
#
#
# Sample Usage:
#
#
define apache::vhost::redirect (
    $port,
    $dest,
    $priority = '10',
    $template = "apache/vhost-redirect.conf.erb"
    ) {

  include apache

  $srvname == $name

  file {"${apache::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

}
