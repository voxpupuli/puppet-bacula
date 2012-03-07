class virtual::ssh_authorized_keys {

  # Key for jenkins slaves to grant access to the jenkins user that's outside
  # of the testing infrastructure
  @ssh_authorized_key { 
    "jenkins/hudson@puppetlabs.com":
      user => "jenkins",
      key  => "AAAAB3NzaC1yc2EAAAABIwAAAQEAsMvODgIqL1NoUgP65qmgf0sJjQy78QdA5rHw9tIwK5KstVSh+0w4TLHJq8Jz8E4UeXhx0NioP3kE3otjCC8kSM5y99QOs4qQh7q6cLN9hQpXMQUD9UnJMP0b5agd0PdErH0ML9hnWfsZX707v31VSIbco+X6Kg9wN8WJhlTXgbbrJTUIPnMzNXrN7Z5/jY6Vss7NTCVI7OxUbIna37l5y8s4jxViaXjoVEXP8e4QtTX8p0BYc2vgerI04ZilhbIe4KEcHiR+n/GUr6MmkY5qtLum/7IZLHbHfWha1q7VaPnz/CHmlDySxxq4sF81N4x2V7d0+x8/wNZx2d+duJmV0Q==",
      type => "rsa",
      tag  => "jenkins";
    "jenkins/jetty@enkal.puppetlabs.com":
      user => "jenkins",
      key  => "AAAAB3NzaC1yc2EAAAABIwAAAQEAxPfb1yjRU7E5cQG9+Eq55WWCsLTRmd/tjv/Ym0Sm+3bsoayfKkd7irZEKlyUlgfNx9IkW45E3o8O+LR2+91U4H+Ao6cxLqyXg/5tqLUyyThkS+KBns7HyxC24nnO3h/84mzC1BCO6p3UAwF4gDtYv1LCxshWuwd0dEUTZFTP8E7Xz6dgKnza0745QnRf4xhx3zRwbjW2iJ97bePNZaZf+EgIDPYcjxqUNr69oCfcC0K11oKuqLpu8pmP4rGC/MxqgadGINEJfP+Y14szE/nIjoEJ71IhP9TEDfEAArPMopqed65xOgo/GVFk8Olhi2+xd2JysiVb6dS5BjjFZpBjuw==",
      type => "rsa",
      tag  => "jenkins";
  }

  @ssh_authorized_key { 'motorola_mobillity':
    user    => 'motorola',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAo/r6KjkRGGR98bTfaNAOExKFJkPTvq2RyTBPEahcm25Lj15KWsT1f4BKUJirlwqe6RerM5DU8h/Nj8WbFJioG09P79oXfJjos801tlSnyEWBxZnHk6ijwKs/R9FVRPp70JMI0BhyC6+3pJfPs71zQdpWQBFaUxTVvZaaazJm8mO0kFBOqWxoWDegf1NxYDmsBL78VAsOYwlI28FrV46LMi/gO8Y0Q1H2qFvE1iJQpeN7fx90/7GiSTsNCBhdUJZsZBSID/WzXRqCFTD5pF0e6Gm6cxz/A3HzsrT6aUgOlfI8nql3AYRG7p8HiCiXKFURCfPVfoIXay1VRo7pLEMxyw==',
    type    => 'ssh-rsa',
    tag     => 'customer',
    options => [
      'no-pty',
      'command="/usr/sbin/nologin"',
      'no-X11-forwarding',
      'no-agent-forwarding',
    ],
  }
}
