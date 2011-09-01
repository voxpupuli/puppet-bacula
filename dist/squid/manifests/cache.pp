class squid::cache {
  include squid
  
  concat::fragment { "cache.conf":
    target => "/etc/squid/squid.conf",
    source => "puppet:///modules/squid/cache.conf",
    order  => 550,
  }
}
