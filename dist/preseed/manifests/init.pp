define preseed (
    $template         = 'preseed/debian_base.cfg.erb',
    $locale           = 'en_US',
    $keymap           = 'us',
    $netcfg_interface = 'auto',
    $proxy            = ''
) {

  file { $name:
    content => template($template),
  }
}
