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
# @param pool
# @param pool_full
# @param pool_inc
# @param pool_diff
# @param storate
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
  Optional[Array] $files    = undef,
  Optional[Array] $excludes = undef,
  Optional[String] $fileset = undef,
  Bacula::JobType $jobtype  = 'Backup',
  $template                 = 'bacula/job.conf.erb',
  $pool                     = $bacula::client::default_pool,
  $pool_full                = $bacula::client::default_pool_full,
  $pool_inc                 = $bacula::client::default_pool_inc,
  $pool_diff                = $bacula::client::default_pool_diff,
  $storage                  = undef,
  $jobdef                   = 'Default',
  Array $runscript          = [],
  $level                    = undef,
  Pattern[/^yes/, /^no/] $accurate                 = 'no',
  $reschedule_on_error      = false,
  $reschedule_interval      = '1 hour',
  $reschedule_times         = '10',
  $messages                 = false,
  $restoredir               = '/tmp/bacula-restores',
  $sched                    = false,
  $priority                 = false,
  $job_tag                  = $bacula::job_tag,
  $selection_type           = undef,
  $selection_pattern        = undef,
) {

  include ::bacula
  $conf_dir = $bacula::conf_dir

  if empty($files) and ! $fileset {
    fail('Must pass either a list of files or a fileset')
  }

  $tag_defaults = ["bacula-${::bacula::director}"]

  if $job_tag {
    $resource_tags = $tag_defaults + [$job_tag]
  } else {
    $resource_tags = $tag_defaults
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
