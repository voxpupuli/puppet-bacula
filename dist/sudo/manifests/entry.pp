define sudo::entry ($entry) {

  $content = "# ${name}\n${entry}\n"

  concat::fragment { 
    "sudoers-entry-$name":
      mode    => '0440',
      target  => '/tmp/sudoers',
      content => "$content",
  }

}
