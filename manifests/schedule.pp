# Define: bacula::schedule
#
# Creates a schedule to which jobs and jobdefs can adhere.
#
define bacula::schedule (
  Array $runs,
  $conf_dir = $bacula::params::conf_dir,
) {

  validate_array($runs)

  concat::fragment { "bacula-schedule-${name}":
    target  => "${conf_dir}/conf.d/schedule.conf",
    content => template('bacula/schedule.conf.erb'),
  }
}
