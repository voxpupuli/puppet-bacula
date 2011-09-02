define squid::config(
  source  = '',
  content = '',
  order   = 1000
) {

  concat::fragment { "squid_config_${name}":
    source  => $source,
    content => $content,
    order   => $order,
    target  => "/etc/squid/squid.conf",
  }
}
