# @summary Configure a Bacula Director Job
#
# This define handles the director portion of a job.  This define should not be
# used directly.  It is intended to be used only from the `bacula::job` define.
#
# This makes it simpler for the director to realize and override the conf_dir
# setting, so that the client conf_dir and the director conf_dir can differ,
# which is useful in a multi platform environment.
#
# @param content  The full content of the job definition
# @param conf_dir Overridden at realize, should not need adjusting
#
# @example from bacula::job
#   @@bacula::director::job { $name:
#     content => template($template),
#     tag     => $real_tags,
#   }
#
define bacula::director::job (
  String               $content,
  Stdlib::Absolutepath $conf_dir = $bacula::conf_dir,
) {
  include bacula

  concat::fragment { "bacula-director-job-${name}":
    target  => "${conf_dir}/conf.d/job.conf",
    content => $content,
    order   => $name,
    tag     => "bacula-${bacula::director_name}",
  }
}
