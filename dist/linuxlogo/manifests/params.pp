class linuxlogo::params {

  $linuxlogo::package = $operatingsystem ? {
    centos  => "linux_logo",
    default => "linuxlogo",
  }
  
  $linuxlogo_conf_content = $operatingsystem ? {
    ubuntu => "#/etc/linux_logo.conf\n-L ubuntu\n",
    debian => "#/etc/linux_logo.conf\n-L debian\n",
    default => "#/etc/linux_logo.conf\n-L 1\n",
  }

}
