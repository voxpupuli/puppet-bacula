class squid {
  include concat::setup
  include squid::params

  package { "squid":
    ensure => present,
  }

  service { "squid":
    ensure  => running,
    enable  => true,
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
