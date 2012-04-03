define preseed (
    $template         = 'preseed/debian_base.cfg.erb',
    $locale           = 'en_US',
    $keymap           = 'us',
    $netcfg_interface = 'auto',
    $proxy            = '',
    $apt_install      = '',
    $upgrade          = 'none'
) {

  file { $name:
    content => template($template),
  }
}
