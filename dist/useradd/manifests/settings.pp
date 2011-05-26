class useradd::settings (
    $last_uid = '29999',
    $last_git = '29999'
  ) {

  case $operatingsystem {
    debian,ubuntu: {
      file {
        "/etc/adduser.conf": 
          owner   => root,
          group   => root,
          mode    => 644,
          content => template("adduser/adduser.conf.erb"),
      }
    }
    default {
    }
  }

}

