# This resource manages zone configuration in Bind.
#
# The goal here is to setup the zone {}; configuration
# options in Bind as a puppet resource.
#
# == Parameters
#
# [name]
#   Name of zone.
# [type]
#   The type of zone.
# [class]
#   Class of zone. Usually IN.
# [file]
#   Path to zone file.
# [allow_update]
#   List of address to allow updates from.
# [custom_config]
#   The custom contents of the zone configuration.
#
# == Examples
#
#   bind::zone { "vms.cloud.bob.sh":
#     type => "master",
#     file => "vms.cloud.bob.sh.zone",
#   }
#
# == Authors
#
# Ken Barber <ken@bob.sh>
#
# == Copyright
#
# Copyright 2011 Puppetlabs Inc, unless otherwise noted.
#
define bind::zone (

  $type           = "master",
  $file           = undef,
  $staticsfile    = undef,
  $initialfile    = undef,
  $source         = undef,
  $class          = "IN",
  $allow_update   = undef,
  $custom_config  = undef

  ) {

  # Pull in some bind:: variables
  include bind::params
  $binduser  = $bind::params::bind_user
  $bindgroup = $bind::params::bind_group

  # Munge the name/file variables around a bit.
  if $file == undef {
    $filename = $name
  } else {
    $filename = $file
  }

  if $filename =~ /\// {
    $real_file = $filename
  } else {
    $real_file =  "${bind::params::bind_zone_dir}/$filename"
  }

  # Make the /etc/bind/ (or wherever) zone.d file, which points to
  # where the file lives etc.
  file { "${bind::params::bind_config_zones_dir}/${name}":
    content => template("${module_name}/zone.conf"),
    notify  => Exec["create_bind_zones_conf"],
  }

  # So, if we have both a staticsfile and an initialfile, we want to
  # just copy the initial file, and use the staticsfile for notifying
  # of updates. If we have one or the other, then probably fail. If we
  # have neither, do what we were doing before.

  #if $staticsfile != undef and $initialfile != undef {
  if $initialfile =~ /^puppet:/ {

  #    # equivilent of basename( ... )
  #    $staticsfilename = regsubst( $staticsfile , '(.*)/(.*)' , '\2' )
      $initialfilename = regsubst( $initialfile , '(.*)/(.*)' , '\2' )

  #    # So we notify on the staticsfile, and ignore the initialfile
  #    # $bindfile_to_notify = ""

  #    file{ "${bind::params::bind_zone_dir}/$staticsfilename":
  #        ensure => file,
  #        source => $staticsfile,
  #        mode   => '0644',
  #        owner  => $binduser,
  #        group  => $bindgroup,
  #        notify => Service[$bind::bind_service],
  #    }

      file{ $real_file:
          replace => false, # don't overwrite it, if it's there.
          ensure  => file,
          mode    => '0644',
          owner   => $binduser,
          group   => $bindgroup,
          source  => $initialfile,
      }

  #} elsif $staticfile != undef or $initialfile != undef {
  #    fail( "Sorry, you need to set both staticfile and initialfile in ${module_name}/${name}" )
  } else {

      # If we have a puppet:// source use that, if we have a blank zone do
      # nothing, and if we don't have it specified, something else.
      if $source =~ /^puppet:/ {

        file{ $real_file:
          ensure => file,
          source => $source,
          notify => Service[$bind::bind_service],
        }
      }
  }

}
