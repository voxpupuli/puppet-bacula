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
  String           $jobtype             = 'Backup',
  String           $sched               = 'Default',
  String           $messages            = 'Standard',
  String           $priority            = '10', # FIXME: Change to Integer
  String           $pool                = 'Default',
  Optional[String] $level               = undef,
  String           $accurate            = 'no', # FIXME: Change to Boolean
  Boolean          $reschedule_on_error = false,
  Bacula::Time     $reschedule_interval = '1 hour',
  String           $reschedule_times    = '10', # FIXME: Change to Integer
  String           $max_concurrent_jobs = '1', # FIXME: Change to Integer
) {

  validate_re($jobtype, ['^Backup', '^Restore', '^Admin', '^Verify', '^Copy', '^Migrate'])

  include ::bacula
  $conf_dir = $bacula::conf_dir

  concat::fragment { "bacula-jobdefs-${name}":
    target  => "${conf_dir}/conf.d/jobdefs.conf",
    content => template('bacula/jobdefs.conf.erb'),
  }
}
