define logrotate::job (
    $log,
    $options,
    $postrotate = "NONE"
  ) {
  # $options should be an array containing 1 or more logrotate directives (e.g. missingok, compress)

  include logrotate

  file { "/etc/logrotate.d/${name}":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("logrotate/logrotate.erb"),
    require => File["/etc/logrotate.d"],
  }

}

