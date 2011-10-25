define apt::source (
  $apt_dir      = "${::apt::apt_dir}",
  $sources_dir  = "${::apt::sources_dir}",
  $source_type  = "deb",
  $uri          = "http://ftp.us.debian.org/debian",
  $distribution = "${lsbdistcodename}",
  $component    = "main",
  $ensure       = present
  ) {

  include apt

  file {
    "aptsource_${name}":
      path    => "${sources_dir}/${name}",
      content => "${source_type} ${uri} ${distribution} ${component}\n",
      owner   => root,
      group   => root,
      mode    => 0644,
      ensure  => $ensure,
      notify  => Exec["apt-get update"],
  }

}

