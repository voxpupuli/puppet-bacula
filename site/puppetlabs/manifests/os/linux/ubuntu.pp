class puppetlabs::os::linux::ubuntu inherits puppetlabs::os::linux {

  include puppetlabs::os::linux::debian

  apt::source { "puppetlabs.list":
    uri          => "http://apt.puppetlabs.com/ubuntu",
  }

}

