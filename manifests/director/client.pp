# @summary Define a Bacula Director Client
#
# This define handles informing the director about a client.  This class should
# not be used directly, but only ever exported through the `bacula::client`
# define.  This is the director's configuration for a given client.
#
# @param address        The address of the Bacula File server daemon
# @param port           The port of the Bacula File server daemon
# @param password       The password to be used when establishing a connection with the File services
# @param file_retention The File Retention directive defines the length of time that Bacula will keep File records in the Catalog database after the End time of the Job corresponding to the File records
# @param job_retention  The Job Retention directive defines the length of time that Bacula will keep Job records in the Catalog database after the Job End time
# @param autoprune      If AutoPrune is set to yes, Bacula will automatically apply the File retention period and the Job retention period for the Client at the end of the Job
# @param conf_dir       The path to the bacula configuration directory
#
# @example Taken from the `bacula::client` define:
#   @@bacula::director::client { $client:
#     port           => $port,
#     password       => $password,
#     autoprune      => $autoprune,
#     file_retention => $file_retention,
#     job_retention  => $job_retention,
#     tag            => "bacula-${director_name}",
#   }
#
define bacula::director::client (
  String                       $address,
  Variant[String,Stdlib::Port] $port, # FIXME: Remove String
  String                       $password,
  Bacula::Time                 $file_retention,
  Bacula::Time                 $job_retention,
  Bacula::Yesno                $autoprune,
  Stdlib::Absolutepath         $conf_dir = $bacula::conf_dir,
) {
  $epp_client_variables = {
    name           => $name,
    address        => $address,
    port           => $port,
    password       => $password,
    file_retention => $file_retention,
    job_retention  => $job_retention,
    autoprune      => $autoprune,
  }

  concat::fragment { "bacula-director-client-${name}":
    target  => "${conf_dir}/conf.d/client.conf",
    content => epp('bacula/bacula-dir-client.epp', $epp_client_variables),
  }
}
