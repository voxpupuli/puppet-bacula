define apt::source (
  $apt_dir      = "/etc/apt",
  $sources_dir  = "/etc/apt/sources.list.d",
  $source_type  = "deb",
  $uri          = "http://ftp.us.debian.org/debian",
  $distribution = "${lsbdistcodename}",
  $component    = "main"
  ) {

  file {
    "aptsource_${name}":
      path    => "${sources_dir}/${name}",
      content => "${source_type} ${uri} ${distribution} ${component}\n",
      owner   => root,
      group   => root,
      mode    => 0644,
      ensure  => present,
      notify  => Exec["apt-get update"],
  }

}
