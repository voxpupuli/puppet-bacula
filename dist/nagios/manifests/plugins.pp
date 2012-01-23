# We make plugins, let make a whole directory of them to make it
# easier to sync!


class nagios::plugins {

  file {'/usr/lib/nagios/plugins/artisan/':
    source  => 'puppet:///nagios/artisan-plugins/',
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

