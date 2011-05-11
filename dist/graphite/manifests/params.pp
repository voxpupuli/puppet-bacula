class graphite::params {
  $build_dir = "/tmp/graphite_build_root"

  $whisper_dl_url = "http://launchpad.net/graphite/1.0/0.9.8/+download/whisper-0.9.8.tar.gz"
  $whisper_dl_loc = "whisper.tar-0.9.8.gz"

  $webapp_dl_url = "http://launchpad.net/graphite/1.0/0.9.8/+download/graphite-web-0.9.8.tar.gz"
  $webapp_dl_loc = "graphite-web-0.9.8.tar.gz"

  $carbon_dl_url = "http://launchpad.net/graphite/1.0/0.9.8/+download/carbon-0.9.8.tar.gz"
  $carbon_dl_loc = "carbon-0.9.8.tar.gz"

  $install_prefix = "/opt/"

  $web_user = $operatingsystem ? {
   centos => "apache",
   default => "www-data"
  }

}

