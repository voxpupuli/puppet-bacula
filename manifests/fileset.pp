# Define: bacula::fileset
#
# A grouping of files to backup.
#
define bacula::fileset (
    $files,
    $excludes = '',
    $options  = {'signature' => 'MD5', 'compression' => 'GZIP'},
  ) {
  validate_hash($options)

  include bacula::common

  @@concat::fragment { "bacula-fileset-${name}":
    target  => '/etc/bacula/conf.d/fileset.conf',
    content => template('bacula/fileset.conf.erb'),
    tag     => "bacula-${bacula::params::bacula_director}";
  }
}
