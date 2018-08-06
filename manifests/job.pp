# Define: bacula::job
#
# This class installs a bacula job on the director.  This can be used for specific applications as well as general host backups
#
# @param files - An array of files that you wish to get backed up on this job for this host.  ie: ["/etc","/usr/local"]
# @param excludes - An array of files to skip for the given job.  ie: ["/usr/local/src"]
# @param fileset - If set to true, a fileset will be genereated based on the files and excludes paramaters specified above. If set to false, the job will attempt to use the fileset named "Common". If set to anything else, provided it's a String, that named fileset will be used.  NOTE: the fileset Common or the defined fileset must be declared elsewhere for this to work. See Class::Bacula for details.
# @param runscript - Array of hash(es) containing RunScript directives.
# @param reshedule_on_error - boolean for enableing disabling job option "Reschedule On Error"
# @param reshedule_interval - string time-spec for job option "Reschedule Interval"
# @param reshedule_times - string count for job option "Reschedule Times"
# @param messages - string containing the name of the message resource to use for this job set to false to disable this option
# @param restoredir - string containing the prefix for restore jobs @param sched - string containing the name of the scheduler set to false to disable this option
# @param priority - string containing the priority number for the job set to false to disable this option
# @param job_tag - string that might be used for grouping of jobs. Pass this to bacula::director to only collect jobs that match this tag.
# @param jobtype
# @param template
# @param pool - string name of the pool to use by default for this job
# @param pool_full - string name of the pool to use for Full jobs
# @param pool_inc - string name of the pool to use for Incremental jobs
# @param pool_diff - string name of the pool to use for Differential jobs
# @param storage
# @param jobdef
# @param level
# @param accurate
# @param reschedule_on_error
# @param reschedule_interval
# @param reschedule_times
# @param sched
# @param selection_type
# @param selection_pattern
#
# @actions
#   * Exports job fragment for consuption on the director
#
# Requires:
#   * Class::Bacula {}
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
  Optional[Array[String]] $files    = undef,
  Optional[Array[String]] $excludes = undef,
  Optional[String] $fileset        = undef,
  Bacula::JobType $jobtype         = 'Backup',
  String            $template            = 'bacula/job.conf.erb',
  Optional[String] $pool           = lookup('bacula::client::default_pool'),
  Optional[String] $pool_full      = lookup('bacula::client::default_pool_full'),
  Optional[String] $pool_inc       = lookup('bacula::client::default_pool_inc'),
  Optional[String] $pool_diff      = lookup('bacula::client::default_pool_diff'),
  Optional[String]  $storage             = undef,
  Variant[Boolean, String]  $jobdef              = 'Default',
  Array[Hash]       $runscript           = [],
  Optional[String]  $level               = undef,
  Boolean           $accurate            = false,
  Boolean           $reschedule_on_error = false,
  Bacula::Time      $reschedule_interval = '1 hour',
  Integer           $reschedule_times    = 10,
  Optional[String]  $messages            = undef,
  String            $restoredir          = '/tmp/bacula-restores',
  Optional[String]  $sched               = undef,
  Optional[Variant[Integer,String]]  $priority   = undef,
  Optional[String] $job_tag        = undef,
  Optional[String]  $selection_type      = undef,
  Optional[String]  $selection_pattern   = undef,
  Integer           $max_concurrent_jobs = 1,
) {

  include bacula
  $conf_dir = $bacula::conf_dir

  if empty($files) and ! $fileset {
    fail('Must pass either a list of files or a fileset')
  }

  $tag_defaults = ["bacula-${::bacula::director_name}"]

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

  @@bacula::director::job { $name:
    content => template($template),
    tag     => $resource_tags,
  }
}
