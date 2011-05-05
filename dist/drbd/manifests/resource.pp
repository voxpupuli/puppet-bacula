# Define: drbd::resource
#
# Configures a drbd resource. For assigning paramaters, the name "peer" is used.  Everywhere else including the templates, the name "remote" is given to specify the non-local information.
#
# Parameters:
#  $peer
#    The name of the peer system to use in the configuration
#  $peer_ip
#    The peer ip address
#  $peer_disk
#    The physical disk to be used by DRBD
#  $peer_device
#    The device to be created by DRBD
#  $peer_port
#    The port to use to talk to the peer
#  $local
#    The name of the local system to use in the configuration
#  $local_ip
#    The local IP address to use for communication of DRBD data
#  $local_disk
#    The physical disk to be used by DRBD
#  $local_device
#    The device to be created by DRBD
#
# Actions:
#   Install the default set of users: [dana,fox]
#
# Requires:
#   * Class["drbd"]
#
# Sample Usage:
#
#  class { "drbd": }
#
#  drbd::resource {
#    "www":
#      peer_ip => '10.0.0.2',
#      peer    => 'web02',
#      device  => '/dev/drbd0',
#      disk    => '/dev/xvdb1'
#  }
#
define drbd::resource (
  $peer,
  $peer_ip,
  $peer_disk    = '',
  $peer_device  = '',
  $peer_port    = '',
  $local        = "$hostname",
  $ip           = "$ipaddress",
  $disk         = '',
  $device       = '',
  $port         = ''
  ){

  # Set the variables used in the template
  $remote       = $peer
  $remote_ip    = $peer_ip
  $local_ip     = $ip
  $local_port   = $port
  $local_disk   = $disk
  $local_device = $device

  # use $disk if no $peer_disk is given
  if ! $peer_disk { $remote_disk = $disk } else { $remote_disk = $peer_disk }
  # use $device if no $peer_device is given
  if ! $peer_device { $remote_device = $device } else { $remote_device = $peer_device }
  # use $port if no $port is given
  if ! $peer_port { $remote_port = $port } else { $remote_port = $peer_port }

  file {
    "/etc/drbd.d/${name}.res":
      owner   => root,
      group   => root,
      mode    => 640,
      content => template("drbd/resource.res.erb"),
      notify  => [Service["drbd"],Exec["drbdadm create-md"]];
  }

  exec {
    "drbdadm create-md":
      command     => "/sbin/drbdadm create-md ${name}",
      refreshonly => true,
      onlyif      => "/sbin/drbdadm dstate ${name} | awk -F/ '{ print \$1 }' | grep -qi diskless",
  }

}

