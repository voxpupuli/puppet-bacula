#
# Defines a simple wrapper for installing a rack app at a sub uri.
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
