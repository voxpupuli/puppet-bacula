# This resource manages keys configuration in Bind.
#
# The goal here is to setup the keys for things.
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
#   bind::key { "dhcp_updater":
#     type => "master",
#     file => "vms.cloud.bob.sh.zone",
#   }
#
# == Authors
#
# Ben Hughes <ben@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppetlabs Inc, unless otherwise noted.
#
define bind::key (
  $algorithm,
  $secret
  ) {

  $keytext = "key ${name} {\n\talgorithm ${algorithm};\n\tsecret \"${secret}\";\n};\n"

  file { "${bind::params::bind_config_keys_dir}/${name}":
    content => $keytext,
    notify  => Exec["create_bind_keys_conf"],
  }

}
