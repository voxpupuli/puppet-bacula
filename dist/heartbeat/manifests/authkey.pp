define heartbeat::authkey (
    $key_id = 0,
    $key = "44d4379a0e273b7a09d81fc55fc57d17ecd4cd46",
    $key_type = "sha1"
  ){

  concat::fragment { "authkey-$key_id":
    target => '/etc/heartbeat/authkeys',
    content => template("heartbeat/authkey.erb"),
  }


}

