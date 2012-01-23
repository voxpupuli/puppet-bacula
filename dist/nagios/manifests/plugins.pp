# We make plugins, let make a whole directory of them to make it
# easier to sync!


class nagios::plugins {

  include nagios::params

  file { '${nagios::params::nagios_plugins_path}/artisan/':
    source  => 'puppet:///nagios/artisan-plugins/',
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

