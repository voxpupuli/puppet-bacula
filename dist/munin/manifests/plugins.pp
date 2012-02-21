class munin::plugins {


  # Am dirty hardcoding this for freebsd to start with, to scratch my
  # itch.

	$plugins = [ 'cpu', 'cupsys_pages',
	#' dev_cpu_',
	'df', 'df_inode', 'env', 'extinfo_tester',
	'fail2ban', 'hddtemp', 'hddtemp2',
	'hddtemp_smartctl', 'hddtempd', 'id',
	#' if_',
	#' if_errcoll_',
	#' ifx_concurrent_sessions_',
	'iostat',
	#' ipmi_sensor_',
	'load', 'lpstat', 'memory', 'netstat',
  'open_files', 'postfix_mailqueue',
	'postfix_mailstats', 'postfix_mailvolume',
	'processes',
	#' smart_',
	'swap', 'systat', 'uptime',
	'users', 'vmstat']

  munin::pluginer{ $plugins: }

}

define munin::pluginer (
  $fromname = undef,
  $ensure = present,
  $pluginpath = "${munin::params::plugin_source}/",
  $plugindest = "${munin::params::plugin_dest}/"
) {

  include munin::params

  if $fromname == undef {
    $sourcename = $name
  } else {
    $sourcename = $fromname
  }

  $realensure = $ensure ? {
    present   => link,
    link      => link,
    "present" => link,
    "link"    => link,
    absent    => absent,
    "absent"  => absent,
  }

  file{ "${plugindest}/${sourcename}":
    ensure => $realensure,
    target => "${pluginpath}/${name}",
    notify => Service['munin-node'],
  }

}

