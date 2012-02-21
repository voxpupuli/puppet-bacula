class munin::plugins {


  # Am dirty hardcoding this for freebsd to start with, to scratch my
  # itch.

  $munin_plugin_path = '/usr/local/share/munin/plugins/'

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

  munin::plugin{ $plugins: }

}

define munin::plugin(
  $name,
  $toname = undef,
  $ensure = present,
  $pluginpath = '/usr/local/share/munin/plugins/',
  $plugindest = '/usr/local/etc/munin/plugins/'
) {

  if $toname == undef {
    $destname = $name
  } else {
    $destname = $toname
  }

  $realensure = $ensure ? {
    present   => link,
    link      => link,
    "present" => link,
    "link"    => link,
    absent    => absent,
    "absent"  => absent,
  }

  file{ "${plugindest}/$destname":
    ensure => $ensure,
    target => $realensure,
  }

}
