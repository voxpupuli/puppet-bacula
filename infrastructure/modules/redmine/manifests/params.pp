class redmine::params {
  $version = '0.8.7'
  $verstr  = "redmine-${version}"
  $url     = "http://github.com/edavis10/redmine/tarball/${version}"
  $base    = '/usr/local/redmine'
  $tgz     = "${base}/${verstr}.tgz"
  $dir     = "${base}/${verstr}"
  $reddir  = "${dir}/edavis10-redmine-78db298"
}
