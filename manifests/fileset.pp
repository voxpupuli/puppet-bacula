# Define: bacula::fileset
#
# A grouping of files to backup.
#
define bacula::fileset (
    $files,
    $excludes = '',
    $options  = {'signature' => 'MD5', 'compression' => 'GZIP'},
    $conf_dir = $bacula::params::conf_dir, # Overridden at realize
  ) {
  validate_hash($options)

  include bacula::common

  @@concat::fragment { "bacula-fileset-${name}":
    target  => "${conf_dir}/conf.d/fileset.conf",
    content => template('bacula/fileset.conf.erb'),
    tag     => "bacula-${bacula::params::bacula_director}";
  }
}
