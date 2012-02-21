#
# Use to install a pacific dir of modules from the module path:
#
# munin::plugins::install{ 'zfs': }
#
# and all the ZFS modules will be installed under the munin plugin
# path.
#

define munin::plugins::install(
  $source = undef,
) {

  include munin::params

  # have to do this, incase $name isn't available at define time.
  if $source == undef {
    $pluginsource = "puppet:///modules/munin/${name}"
  } else {
    $pluginsource = $source
  }

  # install the files, then use them.
  file{ "${munin::params::plugin_source}/${name}":
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => $kernel ? {
      'freebsd' => 'wheel',
      default   => 'root',
    },
    mode    => '0755',
    source  => $pluginsource
  }

}
