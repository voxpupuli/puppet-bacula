# Define: bacula::schedule
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
define bacula::schedule (
    $runs
) {

  concat::fragment {
    "bacula-schedule-${name}":
      target  => '/etc/bacula/conf.d/schedule.conf',
      content => template("bacula/schedule.conf.erb"),
  }

}

