# @summary Define a Bacula Jobdefs
#
# This define adds a jobdefs entry on the bacula director for reference by the client configurations.
#
# @param jobtype                  The Type directive specifies the Job type
# @param sched                    The Schedule directive defines what schedule is to be used for the Job
# @param messages                 The Messages directive defines what Messages resource should be used for this job, and thus how and where the various messages are to be delivered
# @param priority                 This directive permits you to control the order in which your jobs will be run by specifying a positive non-zero number
# @param pool                     The Pool directive defines the pool of Volumes where your data can be backed up
# @param full_backup_pool         The Full Backup Pool specifies a Pool to be used for Full backups
# @param differential_backup_pool The Differential Backup Pool specifies a Pool to be used for Differential backups
# @param level                    The Level directive specifies the default Job level to be run
# @param accurate                 In accurate mode, the File daemon knowns exactly which files were present after the last backup
# @param reschedule_on_error      If this directive is enabled, and the job terminates in error, the job will be rescheduled as determined by the Reschedule Interval and Reschedule Times directives
# @param reschedule_interval      If you have specified Reschedule On Error = yes and the job terminates in error, it will be rescheduled after the interval of time specified by time-specification
# @param reschedule_times         This directive specifies the maximum number of times to reschedule the job
# @param max_concurrent_jobs      Maximum number of Jobs from the current Job resource that can run concurrently
# @param write_bootstrap          The writebootstrap directive specifies a file name where Bacula will write a bootstrap file for each Backup job run
# @param max_full_interval        The time specifies the maximum allowed age (counting from start time) of the most recent successful Full backup that is required in order to run Incremental or Differential backup jobs. f the most recent Full backup is older than this interval, Incremental and Differential backups will be upgraded to Full backups automatically. 
#
define bacula::jobdefs (
  Bacula::JobType        $jobtype                  = 'Backup',
  String                 $sched                    = 'Default',
  String                 $messages                 = 'Standard',
  Integer                $priority                 = 10,
  String                 $pool                     = 'Default',
  Optional[String]       $full_backup_pool         = undef,
  Optional[String]       $differential_backup_pool = undef,
  Optional[String]       $level                    = undef,
  Bacula::Yesno          $accurate                 = false,
  Bacula::Yesno          $reschedule_on_error      = false,
  Bacula::Time           $reschedule_interval      = '1 hour',
  Integer                $reschedule_times         = 10,
  Integer[1]             $max_concurrent_jobs      = 1,
  Optional[String]       $write_bootstrap          = undef,
  Optional[Bacula::Time] $max_full_interval        = undef,
) {
  include bacula
  $conf_dir = $bacula::conf_dir

  $epp_jobdef_variables = {
    name                      => $name,
    jobtype                   => $jobtype,
    pool                      => $pool,
    full_backup_pool          => $full_backup_pool,
    differential_backup_pool  => $differential_backup_pool,
    sched                     => $sched,
    messages                  => $messages,
    priority                  => $priority,
    accurate                  => $accurate,
    level                     => $level,
    max_concurrent_jobs       => $max_concurrent_jobs,
    reschedule_on_error       => $reschedule_on_error,
    reschedule_interval       => $reschedule_interval,
    reschedule_times          => $reschedule_times,
    write_bootstrap           => $write_bootstrap,
    max_full_interval         => $max_full_interval,
  }

  concat::fragment { "bacula-jobdefs-${name}":
    target  => "${conf_dir}/conf.d/jobdefs.conf",
    content => epp('bacula/jobdefs.conf.epp', $epp_jobdef_variables),
  }
}
