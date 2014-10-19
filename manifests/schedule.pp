# Define: bacula::schedule
#
# Creates a schedule to which jobs and jobdefs can adhere.
#
define bacula::schedule (
  $runs
) {

  validate_array($runs)

  concat::fragment { "bacula-schedule-${name}":
    target  => '/etc/bacula/conf.d/schedule.conf',
    content => template('bacula/schedule.conf.erb'),
  }
}
