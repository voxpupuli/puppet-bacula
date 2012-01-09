class denyhosts (
  $adminemail = "root@localhost",
  $allow      = ''
  ) {

  package { "denyhosts": ensure => installed; }

  file { "/etc/denyhosts.conf":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("denyhosts/denyhosts.conf.erb"),
    notify  => Service["denyhosts"],
  }

  service {
    "denyhosts":
      ensure    => running,
      enable    => true,
      hasstatus => false,
      pattern   => "denyhosts",
      require   => Package["denyhosts"],
  }

  file {
    "/etc/hosts.allow":
      content => inline_template('<%= [ allow.to_a.join("\n") , "\n" ].join %>'),
      owner   => root,
      group   => root,
      mode    => 644,
  }

}
