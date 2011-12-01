class puppetlabs::os::linux::ubuntu inherits puppetlabs::os::linux {

  include puppetlabs::os::linux::debian

  apt::source {
    "main.list":
      uri       => "http://us.archive.ubuntu.com/ubuntu/",
      component => "main restricted universe"
  }

  apt::source {
    "security_updates.list":
      uri          => "http://security.ubuntu.com/ubuntu/",
      distribution => "${lsbdistcodename}-updates",
      component    => "main restricted universe",
  }

}

