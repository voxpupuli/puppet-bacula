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
  Bacula::Yesno    $accurate            = false,
  Bacula::Yesno    $reschedule_on_error = false,
  Bacula::Time     $reschedule_interval = '1 hour',
  Integer          $reschedule_times    = 10,
  Integer          $max_concurrent_jobs = 1,
) {

  include bacula
  $conf_dir = $bacula::conf_dir

  $epp_jobdef_variables = {
    name                => $name,
    jobtype             => $jobtype,
    pool                => $pool,
    sched               => $sched,
    messages            => $messages,
    priority            => $priority,
    accurate            => $accurate,
    level               => $level,
    max_concurrent_jobs => $max_concurrent_jobs,
    reschedule_on_error => $reschedule_on_error,
    reschedule_interval => $reschedule_interval,
    reschedule_times    => $reschedule_times,
  }

  concat::fragment { "bacula-jobdefs-${name}":
    target  => "${conf_dir}/conf.d/jobdefs.conf",
    content => epp('bacula/jobdefs.conf.epp', $epp_jobdef_variables),
  }
}
