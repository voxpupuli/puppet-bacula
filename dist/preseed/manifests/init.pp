define preseed (
    $template         = 'preseed/debian_base.cfg.erb',
    $locale           = 'en_US',
    $keymap           = 'us',
    $netcfg_interface = 'auto',
    $proxy            = '',
    $apt_install      = '',
    $upgrade          = 'none',
    $root_pw          = 'toor',
    $make_user        = 'false',
    $tz               = 'US/Vancouver'
) {

  file { $name:
    content => template($template),
  }
}
