define sudo::allowgroup {
  include sudo
  include sudo::params
  $sudoers_tmp  = $::sudo::params::sudoers_tmp

  concat::fragment { 
    "sudoers-group-$name":
      mode    => '0440',
      target  => "$sudoers_tmp",
      content => "%${name} ALL=(ALL) NOPASSWD: ALL\n",
  }

}
