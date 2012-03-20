# Big Scary Storage.
#
# This is for our (currently) two FreeBSD storage boxes.
#
# Just a place to keep their configs and try and keep them the same.
# Most of it isn't related to storage, per se, but it's a class in the
# sense that these boxes are a class.
#

class role::bigscarystorage {

  # Inherits, from a node POV makes more sense here, but that isn't
  # how we roll.
  include role::server

  file { '/etc/sysctl.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    type    => 'file',
    source  => 'puppet:///modules/role/bigscarystorage/etc/sysctl.conf',
  }

  exec{ '/etc/rc.d/sysctl start':
    subscribe   => File['/etc/sysctl.conf'],
    refreshonly => true,
  }

  file { '/boot/loader.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    type    => 'file',
    source  => 'puppet:///modules/role/bigscarystorage/boot/loader.conf',
  }

  file { '/etc/ttys':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    type    => 'file',
    source  => 'puppet:///modules/role/bigscarystorage/etc/ttys',
  }

}
