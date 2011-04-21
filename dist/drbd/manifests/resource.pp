define drbd::resource (
  $peer_ip,
  $peer,
  $device,
  $local = "$hostname",
  $local_ip = "$ipaddress",
  $disk,
  $device,
  $port = '7790'
  ){

  file { 
    "/etc/drbd.d/${name}.res":
      owner => root,
      group => root,
      mode => 640,
      content => template("drbd/resource.res.erb"),
      notify => Service["drbd"];
  }

}

