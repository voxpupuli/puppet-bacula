#
#
# squid.conf layout
#
# 0         header
# 100       access header
# 200       access footer
# 500 - 600 caching settings
# 1000+     default for user defined settings

class squid (
    $monitor = true
  ){
  include concat::setup
  include squid::params

  if $monitor == true {
    include squid::monitor
  }

  package { "squid":
    ensure => present,
  }

  service { "squid":
    ensure  => running,
    enable  => true,
    restart => "/etc/init.d/squid reload",
    require => Package['squid'],
  }

  concat { "/etc/squid/squid.conf":
    owner   => 0,
    group   => 0,
    mode    => '0600',
    require => Package['squid'],
    notify  => Service['squid'],
  }

  concat::fragment { "squid_header.conf":
    target  => "/etc/squid/squid.conf",
    content => template("squid/squid_header.conf.erb"),
    order   => 0,
  }

  concat::fragment { "access_header.conf":
    target  => "/etc/squid/squid.conf",
    source  => "puppet:///modules/squid/access_header.conf",
    order   => 100,
  }

  concat::fragment { "access_footer.conf":
    target  => "/etc/squid/squid.conf",
    source  => "puppet:///modules/squid/access_footer.conf",
    order   => 200,
  }
}
