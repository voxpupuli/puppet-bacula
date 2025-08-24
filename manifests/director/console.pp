# @summary Define a Bacula Director Console
#
# This define creates a console declaration for the director.
# Resources of this type are intended to manage conf.d/console.conf entries.
#
# @param conf_dir    The bacula configuration director.  Should not need adjusting
# @param password    The password that must be supplied for a named Bacula Console to be authorized
# @param jobacl      A list of Job resource names that can be accessed by the console.
# @param clientacl   A list of Client resource names that can be accessed by the console.
# @param storageacl  A list of Storage resource names that can be accessed by the console.
# @param scheduleacl A list of Schedule resource names that can be accessed by the console.
# @param poolacl     A list of Pool resource names that can be accessed by the console.
# @param filesetacl  A list of FileSet resource names that can be accessed by the console.
# @param catalogacl  A list of Catalog resource names that can be accessed by the console.
# @param commandacl  A list of of console commands that can be executed by the console.
# @param whereacl    This directive permits you to specify where a restricted console can restore files.
#
# Aside from Director resource names and console command names,
# the special keyword *all* can be specified in any of the above access control lists.
# When this keyword is present, any resource or command name (which ever is appropriate) will be accepted.
#
# @example
#   bacula::director::console { 'Monitoring':
#     password     => 'monitoring_password',
#   }
#
define bacula::director::console (
  String[1] $password,
  String $conf_dir                   = $bacula::conf_dir,
  String[1] $catalogacl              = '*all*',
  Array[Bacula::Command] $commandacl = ['list'],
  Optional[String[1]] $jobacl        = undef,
  Optional[String[1]] $clientacl     = undef,
  Optional[String[1]] $storageacl    = undef,
  Optional[String[1]] $scheduleacl   = undef,
  Optional[String[1]] $poolacl       = undef,
  Optional[String[1]] $filesetacl    = undef,
  Optional[String[1]] $whereacl      = undef,
) {
  $epp_console_variables = {
    name         => $name,
    password     => $password,
    commandacl   => $commandacl,
    whereacl     => $whereacl,
    jobacl       => $jobacl,
    clientacl    => $clientacl,
    storageacl   => $storageacl,
    scheduleacl  => $scheduleacl,
    poolacl      => $poolacl,
    filesetacl   => $filesetacl,
    catalogacl   => $catalogacl,
  }

  concat::fragment { "bacula-director-console-${name}":
    target  => "${conf_dir}/conf.d/console.conf",
    content => epp('bacula/bacula-dir-console.epp', $epp_console_variables),
  }
}
