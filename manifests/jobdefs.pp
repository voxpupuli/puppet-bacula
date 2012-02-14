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
    $type     = "Backup",
    $schedule = "Default",
    $messages = "Standard",
    $priority = "10"
  ) {

  if defined(Class["bacula"]) {
    # if the fileset is not defined, we fall back to one called "Common"

    @@concat::fragment {
      "bacula-jobdefs-${name}":
        target  => '/etc/bacula/conf.d/jobdefs.conf',
        content => template("bacula/jobdefs.conf.erb"),
        tag     => "bacula-${::bacula::bacula_director}";
    }

  } else {
    err("need Class['bacula'] for this to be useful")
  }
}

