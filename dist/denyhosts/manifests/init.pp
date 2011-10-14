class denyhosts (
  $adminemail = "root@localhost"
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
      ensure  => running,
      enable  => true,
      pattern => "denyhosts",
  }

}
