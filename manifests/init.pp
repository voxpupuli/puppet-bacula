# This class is here to hold the data about a bacula instalation.  The
# parameters in this class are intended to be configured through hiera.  Other
# module classes will reference the values here.
#
# @param bacula_group The posix group for bacula.
# @param bacula_user The posix user for bacula.
# @param conf_dir The path to the bacula configuration directory.
# @param device_seltype SELinux type for the device
# @param director_name
# @param director_address
# @param homedir The bacula user's home directory path
# @param homedir_mode The bacula user's home director mode
# @param job_tag A tag to add to all job resources
# @param monitor Enable the Bacula Monitor option
# @param rundir The run dir for the daemons
# @param storage_name
# @param tls_enable Enable TLS support
# @param tls_require Require TLS connections
# @param tls_certificate The full path and filename of a PEM encoded TLS certificate
# @param tls_key The full path and filename of a PEM encoded TLS private key
# @param tls_verify_peer Verify peer certificate.
# @param tls_allowed_cn Common name attribute of allowed peer certificates
# @param tls_ca_certificate_file The full path and filename specifying a PEM encoded TLS CA certificate(s)
# @param tls_ca_certificate_dir Full path to TLS CA certificate directory
# @param tls_dh_file Path to PEM encoded Diffie-Hellman parameter file
#
# @example
#   include bacula
#
# TODO director_address is confusing, and is only used by the bconsole template
# TODO Document the use of storage_name
# TODO Document the use of director_name
#
class bacula (
  String                  $conf_dir,
  String                  $bacula_user,
  String                  $bacula_group,
  String                  $homedir,
  String                  $rundir,
  String                  $director_address,
  String                  $director_name,
  String                  $storage_name,
  String                  $db_type                 = 'pgsql',
  String                  $homedir_mode            = '0770',
  Bacula::Yesno           $monitor                 = true,
  String                  $device_seltype          = 'bacula_store_t',
  Optional[Bacula::Yesno] $tls_enable              = undef,
  Optional[Bacula::Yesno] $tls_require             = undef,
  Optional[String]        $tls_certificate         = undef,
  Optional[String]        $tls_key                 = undef,
  Optional[Bacula::Yesno] $tls_verify_peer         = undef,
  Array[String]           $tls_allowed_cn          = [],
  Optional[String]        $tls_ca_certificate_file = undef,
  Optional[String]        $tls_ca_certificate_dir  = undef,
  Optional[String]        $tls_dh_file             = undef,
  Optional[String]        $job_tag                 = undef,
){
}
