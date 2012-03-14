#
# Defines a simple wrapper for installing a rack app at a sub uri.
#
# == Parameters
#
# [*doc_root*]
#
# The location of the webserver document root. A symlink in this root will be
# made to the rack app.
#
# [*app_root*]
#
# The location of the rack application.
#
# == Example
#
# rack::app { "jsonp":
#   ensure    => present,
#   doc_root  => "/var/www",
#   app_root => "/opt/freddy",
# }
define rack::app($ensure, $doc_root, $app_root) {

  case $ensure {
    present: { $file_ensure = 'link' }
    absent:  { $file_ensure = 'absent' }
    default: { fail("rack::app ensure needs to be one of [present, absent], got ${ensure}") }
  }


  file { "${doc_root}/${name}":
    ensure => $file_ensure,
    target => "${app_root}/public",
  }
}
