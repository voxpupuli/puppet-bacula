class {
  "nagios::gearman":
    $server => true,
    $key    => hiera("gearman_key")
}

