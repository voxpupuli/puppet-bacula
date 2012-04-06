class graphite::params {

  $graphitedir   = "/opt/graphite"
  $graphiteuser  = "graphite"
  $graphitegroup = "graphite"

  $build_dir = "/tmp/graphite_build_root"

  $series = "0.9"
  $version = "0.9.9"

  $whisper_dl_url = "http://launchpad.net/graphite/${series}/${version}/+download/whisper-${version}.tar.gz"
  $whisper_dl_loc = "whisper-${version}.tar.gz"

  $webapp_dl_url = "http://launchpad.net/graphite/${series}/${version}/+download/graphite-web-${version}.tar.gz"
  $webapp_dl_loc = "graphite-web-${version}.tar.gz"

  $carbon_dl_url = "http://launchpad.net/graphite/${series}/${version}/+download/carbon-${version}.tar.gz"
  $carbon_dl_loc = "carbon-${version}.tar.gz"

  $install_prefix = "/opt/"

  $web_user = $operatingsystem ? {
   centos => "apache",
   default => "www-data"
  }

}

