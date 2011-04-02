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
    comment => 'John Warburton',
    group   => blackrock,
    tag     => customer,
    key     => "AAAAB3NzaC1kc3MAAACBAMckTwxqGtCxHxlMnWUG188kjqchMPo53N+9jDzqxrNEuDo+AVqoMgparLWs5jqKc32MxlW1iKVu+XHH9pgwF8inNsApwPuXxqFjlMm1P/dan3Z7mY0nI7Z51xYue3HVyjVJWTNsgfLpf70MuKl3sQlCPCJ5vdPGEEcRNWvmq9MRAAAAFQDvBtMrya5K8QDdfxEBHPkCUKl6lQAAAIAVYPfUj4GnSkbW73aovldfW6usmffuefW4E6xnjgymi8GkNkW8nyUyhQZYLtWMj/RYU1aB4rZvtTtTALAW9HKbMkaf1naXaPhN7CE/tBWU7QjZkhKghIPUaWGLWguGoHS6Iofe9JtpJLpG1uyhXpeZfti/jyvmgxuyiof63+jH7wAAAIEAuUHePZVYd+KcRP7IQ1Zl+z2xqCuT1jx6CAmbZjgiMoeOLyPBAKzamDfhN+dIlXl55mHBANC8PoRX4BVWHUdLmJtN//JicZK3XVrjgp94bI3bYkC3gtGpefJ4j1eveQyHcVh1fq20/DcnXm6Wh7PEHtduJGz54GwaR84h0=",
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


}

