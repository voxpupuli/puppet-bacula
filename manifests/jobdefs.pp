# Define: bacula::jobdefs
#
# This define adds a jobdefs entry on the bacula director for reference by the client configurations.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define bacula::jobdefs (
  $jobtype             = 'Backup',
  $sched               = 'Default',
  $messages            = 'Standard',
  $priority            = '10',
  $pool                = 'Default',
  $level               = undef,
  $accurate            = 'no',
  $reschedule_on_error = false,
  $reschedule_interval = '1 hour',
  $reschedule_times    = '10',
) {

  validate_re($jobtype, ['^Backup', '^Restore', '^Admin', '^Verify', '^Copy', '^Migrate'])

  include ::bacula
  $conf_dir = $bacula::conf_dir

  concat::fragment { "bacula-jobdefs-${name}":
    target  => "${conf_dir}/conf.d/jobdefs.conf",
    content => template('bacula/jobdefs.conf.erb'),
  }
}
