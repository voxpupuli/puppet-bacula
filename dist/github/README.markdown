# Puppet Github mirroring #

Mirror your massive github mirrors locally, so that you can rapidly create and
destroy repositories before the heat death of the universe!

## Synopsis ##

    class { "github::settings":
      user    => "git",
      group   => "git",
      basedir => "/home/git"
      wwwroot => "/var/www/vhosts/git",
      vhost_name => "git.mydomain.com",
    }

    github::mirror { "puppetlabs/puppet":
      ensure => present,
    }

    github::mirror { "dr_evil/doomsday-device":
      ensure  => present,
      private => true,
    }

