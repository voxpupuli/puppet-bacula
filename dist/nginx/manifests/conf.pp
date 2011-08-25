# Define: nginx::conf
#
#   nginx vhost. For serving web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::conf (
  $template
  ) {

  include nginx
  include nginx::params

  file {
    "${nginx::params::confd}/${name}.conf":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['nginx'],
      notify  => Service['nginx'],
  }

}
# EOF
