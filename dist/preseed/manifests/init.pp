define preseed (
    $template = 'preseed/debian_base.cfg.erb',
    $proxy    = ''
) {

  file { $name:
    content => template($template),
  }
}
