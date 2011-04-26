define sudo::entry ($content) {

  concat::fragment { 
    "sudoers-entry-$name":
      mode    => '0440',
      target  => '/tmp/sudoers',
      content => "$content",
  }

}
