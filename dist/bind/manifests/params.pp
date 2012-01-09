# Bind parameter class. This provides variables to the bind module.
# Not to be used directly.
#
# === OS Support
#
# For now we cover:
#
# * Debian
# * Ubuntu
#
# == Variables
#
# This is a list of variables that must be set for each operating system.
# 
# [bind_package]
#   Package(s) for installing the server.
# [bind_service]
#   Service name for bind.
# [bind_config_dir]
#   Path to main bind configuration directory.
# [bind_config_local]
#   Path to local file we can use for our own work.
# [bind_config_local_content]
#   Contents of local configuration file.
# [bind_user]
#   User that bind runs as.
# [bind_group]
#   Group that bind user belongs to.
#
# == Authors
#
# Ken Barber <ken@bob.sh>
#
# == Copyright
#
# Copyright 2011 Puppetlabs Inc, unless otherwise noted.
#
class bind::params {

  case $operatingsystem {
    'ubuntu', 'debian': {
      $bind_package = "bind9"
      $bind_service = "bind9"
      $bind_user    = "bind"
      $bind_group   = "bind"
      $bind_config_dir       = "/etc/bind"
      $bind_config_zones     = "${bind_config_dir}/named.conf.zones"
      $bind_config_zones_dir = "${bind_config_dir}/zones.d"
      $bind_config_keys      = "${bind_config_dir}/named.conf.keys"
      $bind_config_keys_dir  = "${bind_config_dir}/keys.d"
      $bind_config_local     = "${bind_config_dir}/named.conf.local"
      $bind_config_options   = "${bind_config_dir}/named.conf.options"
      $bind_config_logging   = "${bind_config_dir}/named.conf.logging"
      $bind_zone_dir         = '/var/lib/bind/'
      $bind_restart          = '/usr/sbin/named-checkconf -jz /etc/bind/named.conf && /etc/init.d/bind9 reload'
    }
    default: {
      fail("Operating system ${operatingsystem} is not supported")
    }
  }
}
