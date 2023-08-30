# @summary Define a Bacula Job
#
# This class installs a bacula job on the director.  This can be used for specific applications as well as general host backups
#
# @param files               An array of files that you wish to get backed up on this job for this host.  ie: ["/etc","/usr/local"]
# @param excludes            An array of files to skip for the given job.  ie: ["/usr/local/src"]
# @param fileset             If set to true, a fileset will be genereated based on the files and excludes paramaters specified above. If set to false, the job will attempt to use the fileset named "Common". If set to anything else, provided it's a String, that named fileset will be used.  NOTE: the fileset Common or the defined fileset must be declared elsewhere for this to work. See Class::Bacula for details
# @param jobtype             The type of job
# @param template            Template to use for generating the job configuration fragment
# @param pool                Name of the pool to use by default for this job
# @param pool_full           Name of the pool to use for Full jobs
# @param pool_inc            Name of the pool to use for Incremental jobs
# @param pool_diff           Name of the pool to use for Differential jobs
# @param storage             Name of the storage service to use
# @param jobdef              If a JobDefs-Resource-Name is specified, all the values contained in the named JobDefs resource will be used as the defaults for the current Job
# @param runscript           Array of hash(es) containing RunScript directives
# @param level               The Level directive specifies the default Job level to be run
# @param accurate            In accurate mode, the File daemon knowns exactly which files were present after the last backup. So it is able to handle deleted or renamed files
# @param reschedule_on_error boolean for enableing disabling job option "Reschedule On Error"
# @param reschedule_interval time-spec for job option "Reschedule Interval"
# @param reschedule_times    count for job option "Reschedule Times"
# @param messages            containing the name of the message resource to use for this job set to false to disable this option
# @param restoredir          containing the prefix for restore jobs
# @param sched               containing the name of the scheduler set to false to disable this option
# @param priority            containing the priority number for the job set to false to disable this option
# @param job_tag             that might be used for grouping of jobs. Pass this to bacula::director to only collect jobs that match this tag
# @param selection_type      Determines how the migration job will go about selecting what JobIds to migrate
# @param selection_pattern   Pattern to match against to filter items with selection_type
# @param max_concurrent_jobs Maximum number of Jobs from the current Job resource that can run concurrently
# @param write_bootstrap     The writebootstrap directive specifies a file name where Bacula will write a bootstrap file for each Backup job run
# @param max_full_interval   The time specifies the maximum allowed age (counting from start time) of the most recent successful Full backup that is required in order to run Incremental or Differential backup jobs. f the most recent Full backup is older than this interval, Incremental and Differential backups will be upgraded to Full backups automatically. 
#
# @example
#   bacula::job { "${fqdn}-common":
#     fileset => "Root",
#   }
#
# @example
#   bacula::job { "${fqdn}-mywebapp":
#     files    => ["/var/www/mywebapp","/etc/mywebapp"],
#     excludes => ["/var/www/mywebapp/downloads"],
#   }
#
define bacula::job (
  Array[String]            $files               = [],
  Array[String]            $excludes            = [],
  Optional[String]         $fileset             = undef,
  Bacula::JobType          $jobtype             = 'Backup',
  String                   $template            = 'bacula/job.conf.epp',
  Optional[String]         $pool                = undef,
  Optional[String]         $pool_full           = undef,
  Optional[String]         $pool_inc            = undef,
  Optional[String]         $pool_diff           = undef,
  Optional[String]         $storage             = undef,
  Variant[Boolean, String] $jobdef              = 'Default',
  Array[Bacula::Runscript] $runscript           = [],
  Optional[String]         $level               = undef,
  Bacula::Yesno            $accurate            = false,
  Bacula::Yesno            $reschedule_on_error = false,
  Bacula::Time             $reschedule_interval = '1 hour',
  Integer                  $reschedule_times    = 10,
  Optional[String]         $messages            = undef,
  Stdlib::Absolutepath     $restoredir          = '/tmp/bacula-restores',
  Optional[String]         $sched               = undef,
  Optional[Integer]        $priority            = undef,
  Optional[String]         $job_tag             = undef,
  Optional[String]         $selection_type      = undef,
  Optional[String]         $selection_pattern   = undef,
  Integer[1]               $max_concurrent_jobs = 1,
  Optional[String]         $write_bootstrap     = undef,
  Optional[String]         $max_full_interval   = undef,
) {
  include bacula
  include bacula::client
  $conf_dir = $bacula::conf_dir

  if empty($files) and ! $fileset {
    fail('Must pass either a list of files or a fileset')
  }

  $tag_defaults = ["bacula-${bacula::director_name}"]

  if $job_tag {
    $resource_tags = $tag_defaults + [$job_tag]
  } else {
    if $bacula::job_tag {
      $resource_tags = $tag_defaults + [$bacula::job_tag]
    } else {
      $resource_tags = $tag_defaults
    }
  }

  if $fileset {
    $fileset_real = $fileset
  } else {
    if $files or $excludes {
      $fileset_real = $name
      @@bacula::director::fileset { $name:
        files    => $files,
        excludes => $excludes,
        tag      => $resource_tags,
      }
    } else {
      $fileset_real = 'Common'
    }
  }

  $epp_job_variables = {
    name                => $name,
    jobtype             => $jobtype,
    fileset_real        => $fileset_real,
    pool                => $pool.lest || { $bacula::client::default_pool },
    storage             => $storage,
    restoredir          => $restoredir,
    messages            => $messages,
    pool_full           => $pool_full.lest || { $bacula::client::default_pool_full },
    pool_inc            => $pool_inc.lest || { $bacula::client::default_pool_inc },
    pool_diff           => $pool_diff.lest || { $bacula::client::default_pool_diff },
    selection_type      => $selection_type,
    selection_pattern   => $selection_pattern,
    jobdef              => $jobdef,
    runscript           => $runscript,
    accurate            => $accurate,
    level               => $level,
    sched               => $sched,
    priority            => $priority,
    max_concurrent_jobs => $max_concurrent_jobs,
    reschedule_on_error => $reschedule_on_error,
    reschedule_interval => $reschedule_interval,
    reschedule_times    => $reschedule_times,
    write_bootstrap     => $write_bootstrap,
    max_full_interval   => $max_full_interval,
  }

  @@bacula::director::job { $name:
    content => epp($template, $epp_job_variables),
    tag     => $resource_tags,
  }
}
