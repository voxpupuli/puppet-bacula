define sudo::allowgroup {

  concat::fragment { 
    "sudoers-group-$name":
      mode    => '0440',
      target  => '/tmp/sudoers',
      content => "%${name} ALL=(ALL) NOPASSWD: ALL\n",
  }

}
