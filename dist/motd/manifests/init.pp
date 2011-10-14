# Ripped from - https://github.com/ripienaar/puppet-concat
#

# class to setup basic motd, include on all nodes
class motd {
  include motd::params
  include concat::setup

  $motd = $motd::params::motd

  concat{ $motd:
     owner   => root,
     mode    => 644
  }

  concat::fragment{"motd_header":
     target  => $motd,
     content => template( 'motd/motd.erb' ),
     order   => 02,
  }

  # local users on the machine can append to motd by just creating
  # /etc/motd.local
  concat::fragment{"motd_local":
     target  => $motd,
     ensure  => "/etc/motd.local",
     order   => 15
  }
}
