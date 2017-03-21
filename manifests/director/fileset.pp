# This class handles a Director's fileset.conf entry.  Filesets are intended to
# be included on the Director catalog.  Resources of this type may also be
# exported to be realized by the director.
#
# @param files
# @param conf_dir The bacula configuration director.  Should not need adjusting.
# @param excludes A list of paths to exclude from the filest
# @param options A hash of options to include in the fileset
# @param director_name The name of the director intended to receive this fileset.
#
# @example
#   bacula::director::fileset { 'Home':
#     files => ['/home'],
#   }
#
define bacula::director::fileset (
  Array $files,
  String $conf_dir                              = $::bacula::conf_dir,
  String $director_name                         = $::bacula::director_name,
  Optional[Array] $excludes                     = [],
  Hash[String, Variant[String, Array]] $options = {
    'signature'   => 'SHA1',
    'compression' => 'GZIP9',
  },
) {

  concat::fragment { "bacula-fileset-${name}":
    target  => "${conf_dir}/conf.d/fileset.conf",
    content => template('bacula/fileset.conf.erb'),
    tag     => "bacula-${director_name}",
  }
}
