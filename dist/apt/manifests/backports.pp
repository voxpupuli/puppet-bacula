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
class apt::backports( $release=undef ) {

  if $release == undef {
    $releasename = $lsbdistcodename
  } else {
    $releasename = $release
  }

  case $operatingsystem {
    'Debian': {
      $repourl = 'http://backports.debian.org/debian-backports'
      $repocomponent = 'main'
    }
    'Ubuntu': {
      $repourl = 'http://archive.ubuntu.com/ubuntu'
      $repocomponent = 'universe multiverse restricted'
    }
    default: {
      fail( "$module_name is Debian & Umbongo only." )
    }
  }

  # Do this, as per http://backports-master.debian.org/Instructions/
  # so we get backports updates.
  apt::pin { '*':
    release  => "${releasename}-backports",
    priority => '200',
    filename => 'star'
  }

  file { '/etc/apt/sources.list.d/backports.list':
    ensure   => file,
    content  => "deb ${repourl} ${releasename}-backports ${repocomponent}",
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
  }

  exec { 'Refresh apt cache after adding backports':
    command     => '/usr/bin/aptitude --quiet update',
    refreshonly => 'true',
    subscribe   => File['/etc/apt/sources.list.d/backports.list'],
  }
}
