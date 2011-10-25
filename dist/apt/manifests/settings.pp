class apt::settings (
    $proxy = undef
  ){

  if $proxy {
    file {
      "/etc/apt/apt.conf.d/01proxy": 
        content => "Acquire::http::Proxy \"$proxy\";\n",
    }
  }

}
