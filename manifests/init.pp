# This class is here to hold the data about a bacula instalation.  The
# parameters in this class are intended to be configured through hiera.  Other
# module classes will reference the values here.
#
# @param bacula_group The posix group for bacula.
# @param bacula_user The posix user for bacula.
# @param conf_dir The path to the bacula configuration directory.
# @param device_seltype SELinux type for the device
# @param director
# @param director_address
# @param homedir The bacula user's home directory path
# @param homedir_mode The bacula user's home director mode
# @param job_tag A tag to add to all job resources
# @param monitor Enable the Bacula Monitor option
# @param rundir The run dir for the daemons
# @param storage
# @param use_ssl Configure SSL, see README
#
# @example
#   include bacula
#
# TODO director_address is confusing, and is only used by the bconsole template
# TODO Document the use of storage
# TODO Document the use of director
# TODO Consider renaming the director param to director_name to be more clear
# TODO Consider renaming the storage param to storage_name to be more clear
#
class bacula (
  String $conf_dir,
  String $bacula_user,
  String $bacula_group,
  String $homedir,
  String $rundir,
  String $director_address,
  String $director,
  String $storage,
  String $homedir_mode      = '0770',
  Boolean $monitor          = true,
  String $device_seltype    = 'bacula_store_t',
  Boolean $use_ssl          = false,
  Optional[String] $job_tag = undef,
){

  if $use_ssl {
    include ::bacula::ssl
  }
}
