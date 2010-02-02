#
# This is a MVP for a vhost definition
#
define apache::vhost ($enabled='true', $source) { 
  $site_available = "/etc/apache2/sites-available/${name}"  
  $site_enabled = "/etc/apache2/sites-enabled/${name}"  
  File { notify => Service['apache2'] }
  file { $site_available: ensure => present, source => $source, owner => root, group => root, mode => 644, }   
  file { $site_enabled: ensure => $site_available ? { default => absent, true => $available,  }} 
}
