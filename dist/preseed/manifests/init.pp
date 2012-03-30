define preseed (
    $template = 'preseed/debian_base.cfg'
) {

  file { $name:
    content => template($template),
  }
}
