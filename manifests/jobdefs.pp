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
  Bacula::JobType  $jobtype             = 'Backup',
  String           $sched               = 'Default',
  String           $messages            = 'Standard',
  Integer          $priority            = 10,
  String           $pool                = 'Default',
  Optional[String] $level               = undef,
  Boolean          $accurate            = false,
  Boolean          $reschedule_on_error = false,
  Bacula::Time     $reschedule_interval = '1 hour',
  Integer          $reschedule_times    = 10,
  Integer          $max_concurrent_jobs = 1,
) {

  include bacula
  $conf_dir = $bacula::conf_dir

  concat::fragment { "bacula-jobdefs-${name}":
    target  => "${conf_dir}/conf.d/jobdefs.conf",
    content => template('bacula/jobdefs.conf.erb'),
  }
}
