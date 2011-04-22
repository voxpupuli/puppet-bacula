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
      notify => [Service["drbd"],Exec["drbdadm create-md"]];
  }

  exec {
    "drbdadm create-md":
      command => "/sbin/drbdadm create-md ${name}",
      refreshonly => true,
      onlyif => "/sbin/drbdadm dstate ${name} | awk -F/ '{ print \$1 }' | grep -qi diskless",
  }

}

