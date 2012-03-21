define gitolite::adc($ensure = present, $source = "puppet:///modules/gitolite/adc/${name}", $mode = '0700'){

  require gitolite::instance

  validate_re('^present$|^absent$', $ensure)
  $gl_adc_path = hiera('gitolite_rc_gl_adc_path', 'UNSET')

  # There appears to be a bug with the hiera puppet back end for reading
  # module data, so we use fully scoped variables for data.
  $user  = $gitolite::data::gitolite_instance_user
  $group = $gitolite::data::gitolite_instance_group

  if $adc_path == 'UNSET' {
    err("${module_name}::Adc[${name}] ensure is present but ADCs are disabled; this will do nothing!")
  }
  else {

    # Ensure ADC directory exists.
    if !defined(File[$gl_adc_path]) {
      file { $gl_adc_path:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0700',
        purge  => true,
      }
    }

    file { "${gl_adc_path}/${name}":
      ensure  => $ensure,
      owner   => $user,
      group   => $group,
      source  => $source,
      mode    => $mode,
      require => File[$gl_adc_path],
    }
  }
}
