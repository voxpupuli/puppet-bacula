define apt::key(
  $id,
  $url,
) {

  exec { "import_${name}_aptkey":
    user    => 'root',
    command => "wget -q -O - ${url} | apt-key add -",
    unless  => "apt-key list | grep -q ${id}",
    path    => '/bin:/usr/bin',
  }

}
