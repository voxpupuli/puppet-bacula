class virtual::users::customers {
  include virtual::groups
  @account::user {'menglund':
    comment => 'Martin Englund',
    usekey  => false,
    group   => vmware,
    tag     => customer,
    expire  => "2011-04-01",
  }

  @account::user {'davepark':
    comment => 'Dave Park',
    group   => motorola,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAo/r6KjkRGGR98bTfaNAOExKFJkPTvq2RyTBPEahcm25Lj15KWsT1f4BKUJirlwqe6RerM5DU8h/Nj8WbFJioG09P79oXfJjos801tlSnyEWBxZnHk6ijwKs/R9FVRPp70JMI0BhyC6+3pJfPs71zQdpWQBFaUxTVvZaaazJm8mO0kFBOqWxoWDegf1NxYDmsBL78VAsOYwlI28FrV46LMi/gO8Y0Q1H2qFvE1iJQpeN7fx90/7GiSTsNCBhdUJZsZBSID/WzXRqCFTD5pF0e6Gm6cxz/A3HzsrT6aUgOlfI8nql3AYRG7p8HiCiXKFURCfPVfoIXay1VRo7pLEMxyw==",
    keytype => "ssh-rsa",
    #expire  => "2010-04-01",
  }
  @account::user {'oliverhookins':
    comment => 'Oliver Hookins',
    group   => nokia,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAyTUgpm13ttBA+hrEL3himqNO4OlfPPBUMpd8OzzTjJwIO5t5bjckV+C0mSUKvz3y9SB2akTJwdBcEmFct0OjNewbn3ogOFphb85zcaz8FEpUbgOn+lYs3iCgAM7YxkRwRsd/yqvawIYt+SAi1Vdg/GlGb8eJaTRWP4NsFkJ9cqGi2AU/eQZ+0G6aWlKyovVs+LzQU81OoeArqwuqL81043dkOnswfropm9FCLFOlXrIOuuMQcg6CDEdpkOiaaUansz9spQN9SHFybjCwYihNzcBJztH+v6ukMphJV0PI/uF3Y7q2ClWXvKAFSJ3E2/lyrZesw+Pt23oCCfzwQr3jmQ==",
    keytype => "ssh-rsa",
    #expire  => "2011-04-01",
  }

  @account::user {'johnwarburton':
    comment => 'john.warburton@blackrock.com',
    group   => blackrock,
    tag     => customer,
    key     => "AAAAB3NzaC1kc3MAAACBALN2FRuRnOX0IAYSQzbWYLlgdQ9Fyl/ns4Y5nQGtgTI8GZVPjfJ9yQ6DXMNRfM6fG1dDYZJ4oBqXGe0Xm/fBPK9Vup1LryiDsG8AroKPYgmNaOBI+aTKlO8mjpJ0G6fcddSiiTU9QShTqw+KzIXjO3RIzdyQnCKZP1x78cQ+8rabAAAAFQD/n+1l8hgDBMTzwjJwcBrjmR0h0wAAAIBHgTdRHpva0o8HMlgaANP05fwgKayPTfGTeRJKQ2oBehP8zEmourlCjsydSQaws/L4qaDREJ6YE51F5pqBry9mwvXuBsr5wkzUkQIdL9Wr1YQF+xVSMD5TU/yLBOtVLG5ipVUtSMxAXCzv0Wm9h6Hp3q8HFCSiYSmpnWcTNiCFywAAAH8J2pQGpyDVY7LOhnpDbANdIrW7MQJzFG/HyZt/ZcFTKxdECjb+oRQifd6uJKoxAnyNAjKqjqhRHlzDeiZ8tps8VX9sZJBN1Dqh+2aJLcFz+B4Zb5WGhSCFAkjFgB+dzS64voxCvGK6Yd151pp1c4o35QeMJlBw8SgijGCb2JbJ",
    keytype => "ssh-dss",
  }

  @account::user {'byronpezan':
    comment => 'Byron Pezan',
    group   => secureworks,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAIEAvuEP2fui7dtSrCjNVBtlPh6p3dYmiz/Jmrn/MxtPNYizBAVvPCjTOuK9m9LIX4mZ9x9wMlYNfv4IQbbVYIQb6z/wAUe2lw6+YpHt+DC4MCbLS1vHsJM2+8MQE8IGEOMrkivZ1n0C/tuQshJ/mauYS39KQEX81ShzJ9OMKd9Xa4k=",
    keytype => "ssh-rsa",
    expire  => "2011-05-01",
  }

  @account::user {'joerizzo':
    comment => 'Joe Rizzo',
    usekey  => false,
    group   => bioware,
    tag     => customer,
    expire  => "2011-05-01",
  }

  @account::user {'eishaysmith':
    comment => 'Eishay Smith',
    group   => wealthfront,
    tag     => customer,
    expire  => "2011-07-01",
  }
}

