define bacula::director::job (
  $conf_dir = $bacula::params::conf_dir, # Overridden at realize
  $content
) {

  concat::fragment { "bacula-director-job-${name}":
    target  => "${conf_dir}/conf.d/job.conf",
    content => $content,
    tag     => "bacula-${::bacula::params::bacula_director}";
  }
}
