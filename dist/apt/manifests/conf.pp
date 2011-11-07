define apt::conf (
  $priority='50',
  $content
  ){

  include apt

  $apt_dir      = "${::apt::apt_dir}"
  $aptconf_dir  = "${::apt::aptconf_dir}"

  file { "${aptconf_dir}/${priority}${name}":
    content => $content,
    owner   => root,
    group   => root,
    mode    => 0644,
  }

}
