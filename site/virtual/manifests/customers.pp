class virtual::customers {
  include virtual::groups
  @account::user {'menglund':
    comment => 'Martin Englund',
    usekey  => false,
    group   => vmware,
    tag     => customer,
    expiry  => "2010-04-01",
  }

  @account::user {'davepark':
    comment => 'Dave Park',
    group   => motorola,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAo/r6KjkRGGR98bTfaNAOExKFJkPTvq2RyTBPEahcm25Lj15KWsT1f4BKUJirlwqe6RerM5DU8h/Nj8WbFJioG09P79oXfJjos801tlSnyEWBxZnHk6ijwKs/R9FVRPp70JMI0BhyC6+3pJfPs71zQdpWQBFaUxTVvZaaazJm8mO0kFBOqWxoWDegf1NxYDmsBL78VAsOYwlI28FrV46LMi/gO8Y0Q1H2qFvE1iJQpeN7fx90/7GiSTsNCBhdUJZsZBSID/WzXRqCFTD5pF0e6Gm6cxz/A3HzsrT6aUgOlfI8nql3AYRG7p8HiCiXKFURCfPVfoIXay1VRo7pLEMxyw==",
    keytype => "ssh-rsa",
    expiry  => "2010-04-01",
  }
  @account::user {'oliverhookins':
    comment => 'Oliver Hookins',
    group   => nokia,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAyTUgpm13ttBA+hrEL3himqNO4OlfPPBUMpd8OzzTjJwIO5t5bjckV+C0mSUKvz3y9SB2akTJwdBcEmFct0OjNewbn3ogOFphb85zcaz8FEpUbgOn+lYs3iCgAM7YxkRwRsd/yqvawIYt+SAi1Vdg/GlGb8eJaTRWP4NsFkJ9cqGi2AU/eQZ+0G6aWlKyovVs+LzQU81OoeArqwuqL81043dkOnswfropm9FCLFOlXrIOuuMQcg6CDEdpkOiaaUansz9spQN9SHFybjCwYihNzcBJztH+v6ukMphJV0PI/uF3Y7q2ClWXvKAFSJ3E2/lyrZesw+Pt23oCCfzwQr3jmQ==",
    keytype => "ssh-rsa",
    expiry  => "2010-04-01",
  }


}

