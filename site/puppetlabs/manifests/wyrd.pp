class puppetlabs::wyrd {

#  class {
#    "puppet::master::unicorn":
#  }

  unicorn::app {
    "puppetmaster":
      approot => "/etc/puppet",
      config  => "/etc/puppet/unicorn.conf",
      require => File["/etc/puppet/unicorn.conf"],
      initscript => "puppet/unicorn_puppetmaster",
  }

  file {
    "/etc/puppet/unicorn.conf":
      owner  => root,
      group  => root,
      mode   => 644,
      source => "puppet:///modules/puppet/unicorn.conf";
  }

}

