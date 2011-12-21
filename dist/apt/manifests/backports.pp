# This adds the necessary components to get backports for ubuntu and debian
#
# == Parameters
#
# [*release*]
#   The ubuntu/debian release name. Defaults to $lsbdistcodename. Setting this
#   manually can cause undefined behavior. (Read: universe exploding)
#
# == Examples
#
#   include apt::backports
#
#   class { 'apt::backports':
#     release => 'natty',
#   }
#
# == Authors
#
# Ben Hughes, I think. At least blame him if this goes wrong. I just added puppet doc.
#
# == Copyright
#
# Copyright 2011 Puppet Labs Inc, unless otherwise noted.
class apt::backports( $release=$lsbdistcodename ) {
  include apt

  case $operatingsystem {
    'Debian','Ubuntu': {
      apt::source {
        "backports.list":
          uri       => $lsbdistid ? {
            "debian" => "http://backports.debian.org/debian-backports",
            "ubuntu" => "http://archive.ubuntu.com/ubuntu",
          },
          distribution => "${releasename}-backports",
          component => $lsbdistid ? {
            "debian" => "main",
            "ubuntu" => "universe multiverse restricted",
          },
          notify => Exec["apt-get update"],
      }
    }
    default: {
      fail( "$module_name is Debian & Umbongo only." )
    }
  }

  # Do this, as per http://backports-master.debian.org/Instructions/
  # so we get backports updates.
  apt::pin { "${releasename}-backports":
    release  => "${releasename}-backports",
    priority => '200',
    wildcard => true,
    filename => 'backports_pin',
  }

}

