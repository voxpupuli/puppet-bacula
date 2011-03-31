# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $template option specifies whether to use the default template or override
# - The $priority of the site
# - The $serveraliases of the site
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The apache class
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    priority => '20',
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define apache::vhost( 
    $port,
    $docroot,
    $ssl           = true,
    $template      = 'apache/vhost-default.conf.erb',
    $priority      = '25',
    $servername    = '',
    $serveraliases = '',
    $auth          = false,
    $redirect_ssl  = false
  ) {

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::ssl
  }
  
  # Since the template will use auth, redirect to https requires mod_rewrite
  if $redirect_ssl == true {
    case $operatingsystem {
      'debian','ubuntu': {
        A2mod <| title == 'rewrite' |>
      }
      default: { }
    }
  }

  file {
    "${apache::params::vdir}/${priority}-${name}":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['httpd'],
      notify  => Service['httpd'],
  }

}

