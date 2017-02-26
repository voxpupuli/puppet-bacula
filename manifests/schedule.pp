# Creates a schedule to which jobs and jobdefs can adhere.
#
# @param runs A list of Bacula Run directives
# @param conf_dir Path to bacula configuration directory
#
# @example
#   bacula::schedule { 'Regularly':
#     runs => [
#       'Level=Incremental monday-saturday at 12:15',
#       'Level=Incremental monday-saturday at 0:15',
#       'Level=Full sunday at 0:05',
#     ]
#   }
#
define bacula::schedule (
  Array $runs,
  String $conf_dir = $bacula::conf_dir,
) {

  concat::fragment { "bacula-schedule-${name}":
    target  => "${conf_dir}/conf.d/schedule.conf",
    content => template('bacula/schedule.conf.erb'),
  }
}
