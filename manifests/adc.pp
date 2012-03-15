define gitolite::adc($ensure = present, $source){

  require gitolite::instance

  validate_re('^present$|^absent$')
  $gl_adc_path = hiera('gitolite_rc_gl_adc_path', undef)
  $user        = hiera('gitolite_instance_user')
  $group       = hiera('gitolite_instance_group')

  if ! $gl_adc_path {
    notify {'Gitolite ADC warning':
      message => "The ${module_name}::${name} ADC ensure is present but ADCs are disabled; this will do nothink!";
    }
  }

  file { "${gl_adc_path}/${name}":
    ensure => $ensure,
    user   => $user,
    group  => $group,
    source => $source,
  }
}
