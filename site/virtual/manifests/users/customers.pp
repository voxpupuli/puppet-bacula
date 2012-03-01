class virtual::users::customers {
  include virtual::groups

  ### Customer Accounts ###
  # UID range 21000-21999
  #

  @account::user {'menglund':
    ensure  => absent,
    comment => 'Martin Englund',
    usekey  => false,
    group   => vmware,
    tag     => customer,
    expire  => "2011-04-01",
  }

  @account::user {'davepark':
    ensure  => absent,
    comment => 'Dave Park',
    group   => motorola,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAo/r6KjkRGGR98bTfaNAOExKFJkPTvq2RyTBPEahcm25Lj15KWsT1f4BKUJirlwqe6RerM5DU8h/Nj8WbFJioG09P79oXfJjos801tlSnyEWBxZnHk6ijwKs/R9FVRPp70JMI0BhyC6+3pJfPs71zQdpWQBFaUxTVvZaaazJm8mO0kFBOqWxoWDegf1NxYDmsBL78VAsOYwlI28FrV46LMi/gO8Y0Q1H2qFvE1iJQpeN7fx90/7GiSTsNCBhdUJZsZBSID/WzXRqCFTD5pF0e6Gm6cxz/A3HzsrT6aUgOlfI8nql3AYRG7p8HiCiXKFURCfPVfoIXay1VRo7pLEMxyw==",
    keytype => "ssh-rsa",
    #expire  => "2010-04-01",
  }
  @account::user {'oliverhookins':
    ensure  => absent,
    comment => 'Oliver Hookins',
    group   => nokia,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAyTUgpm13ttBA+hrEL3himqNO4OlfPPBUMpd8OzzTjJwIO5t5bjckV+C0mSUKvz3y9SB2akTJwdBcEmFct0OjNewbn3ogOFphb85zcaz8FEpUbgOn+lYs3iCgAM7YxkRwRsd/yqvawIYt+SAi1Vdg/GlGb8eJaTRWP4NsFkJ9cqGi2AU/eQZ+0G6aWlKyovVs+LzQU81OoeArqwuqL81043dkOnswfropm9FCLFOlXrIOuuMQcg6CDEdpkOiaaUansz9spQN9SHFybjCwYihNzcBJztH+v6ukMphJV0PI/uF3Y7q2ClWXvKAFSJ3E2/lyrZesw+Pt23oCCfzwQr3jmQ==",
    keytype => "ssh-rsa",
    #expire  => "2011-04-01",
  }

  @account::user {'johnwarburton':
    ensure  => absent,
    comment => 'john.warburton@blackrock.com',
    group   => blackrock,
    tag     => customer,
    key     => "AAAAB3NzaC1kc3MAAACBALN2FRuRnOX0IAYSQzbWYLlgdQ9Fyl/ns4Y5nQGtgTI8GZVPjfJ9yQ6DXMNRfM6fG1dDYZJ4oBqXGe0Xm/fBPK9Vup1LryiDsG8AroKPYgmNaOBI+aTKlO8mjpJ0G6fcddSiiTU9QShTqw+KzIXjO3RIzdyQnCKZP1x78cQ+8rabAAAAFQD/n+1l8hgDBMTzwjJwcBrjmR0h0wAAAIBHgTdRHpva0o8HMlgaANP05fwgKayPTfGTeRJKQ2oBehP8zEmourlCjsydSQaws/L4qaDREJ6YE51F5pqBry9mwvXuBsr5wkzUkQIdL9Wr1YQF+xVSMD5TU/yLBOtVLG5ipVUtSMxAXCzv0Wm9h6Hp3q8HFCSiYSmpnWcTNiCFywAAAH8J2pQGpyDVY7LOhnpDbANdIrW7MQJzFG/HyZt/ZcFTKxdECjb+oRQifd6uJKoxAnyNAjKqjqhRHlzDeiZ8tps8VX9sZJBN1Dqh+2aJLcFz+B4Zb5WGhSCFAkjFgB+dzS64voxCvGK6Yd151pp1c4o35QeMJlBw8SgijGCb2JbJ",
    keytype => "ssh-dss",
  }

  @account::user {'byronpezan':
    ensure  => absent,
    comment => 'Byron Pezan',
    group   => secureworks,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAIEAvuEP2fui7dtSrCjNVBtlPh6p3dYmiz/Jmrn/MxtPNYizBAVvPCjTOuK9m9LIX4mZ9x9wMlYNfv4IQbbVYIQb6z/wAUe2lw6+YpHt+DC4MCbLS1vHsJM2+8MQE8IGEOMrkivZ1n0C/tuQshJ/mauYS39KQEX81ShzJ9OMKd9Xa4k=",
    keytype => "ssh-rsa",
    expire  => "2011-05-01",
  }

  @account::user {'joerizzo':
    ensure  => absent,
    comment => 'Joe Rizzo',
    usekey  => false,
    group   => bioware,
    tag     => customer,
    expire  => "2011-05-01",
  }

  @account::user {'eishaysmith':
    ensure  => absent,
    comment => 'Eishay Smith',
    group   => wealthfront,
    tag     => customer,
    expire  => "2011-07-01",
  }

  # tlinkin@advance.net
  @account::user {'tomlinkin':
    uid     => '21002',
    ensure  => absent,
    comment => 'Tom Linkin',
    group   => advance,
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAwE4+j2WIqTcIhci2qFlTlNF3Hf+DwHgPwfsAu2tp/xG9yxQuY8nt8w8JZr/eIPHq2SPhCM7KoXurO9k0TpVGDd4fqHY6FG6izt4keE0Itaclhn4mbW1UecFutPjKuMcyfWczwnalCyyCkHuNahuMPH9RDv9IP+9SDU2XTFKdNO5QtRtkD7lTAaMrOlCPntFglX3WnTYkpuTm1k7zzLrKclMalXS16C2KIItIhyUo1p0zQ7wrVPxGyOilPrTpfcmnfNH82DLhsIlSqoESgsbVAr6fO4/l1p5Q/fwmmPSm9tEngaeKJcaWcjtmOg6fFnMV1i5zTOZAcOk8eKS84O8sgw==",
    keytype => "ssh-rsa",
    expire  => "2011-08-19",
  }

  # SCEA, #10214
  @account::user {'scea':
    ensure  => absent,
    uid     => 21001,
    comment => 'scea',
    group   => 'scea',
    tag     => customer,
    key     => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCyA10XNKjUlfsMXn4qI2nAnGUlc6cz+AH/gNFY2Pbvy4ziv0jxacT+0AjwI5BXz9yNk4kERKeLC9K0lRYr6yi7iZV1Sy8bfXeRU/NyUS5YsbNdQYtGtZ6gkZ3KLWunaiDaWla09IsyQFdvzaYH0dvpubq185OXjkcE7dypUn6/IlwkOE+uXxrfdrpqXxXZQ0HgKEL1K89d9VbbDuxJt9JfI3VwWhkAXj+M0Ffe4X1BLzhhFbKYXYeHaPPEv2WR4/XxuED033eYgjiAmPU3KNCB0pmWQujFR+1IBvHMKYii3YgPU4xX9cvQymvVi0uZ+gHYPe195bFyIW2PVn6pgM59",
    keytype => "ssh-rsa",
    expire  => "2011-11-30",
  }

  # (#12410) McGraw Hill Evaluation',
  @account::user {'mcgraw':
    ensure  => absent,
    uid     => '21003',
    group   => 'mcgraw',
    tag     => 'customer',
    comment => '(12410) McGraw Hill',
    usekey  => 'false',
    expire  => "2012-02-28",
  }

  @account::user {'jbarton':
    ensure  => absent,
    uid     => '21004',
    group   => 'suddenlink',
    comment => 'Support ticket 773',
    key     => 'AAAAB3NzaC1kc3MAAAEBAN+JQvgC7toRwmCuohoM0ueawFyk832RE+gFwiGo3qpBaNkFgz7zghBdT4HnsXGDClEkKSoHWPaNhpGlzCE0MAXXjQMZHrrMpdr11c/msPu8OVCvVoEk3G/VabwIrUh3Mw2oElWJrBSxXvfDyHK9TmZ0oElEl8bKKHIOSQDuHG0nXN+KoxwuOsB4ohRERMICWi2ZVbpgyVJZRutFpwQHm5z5Rfbg31lzCUEsyTgEF56He+v1NTVV6W4Z9NAusS4iQl30r1gX1D2ymVGGcbN22/0VRqPpaAkpdlmtXuYEwWF3CY32RCIannCEAjJ9NyPcQB1Y5IGYaYBY8gzgFux1LacAAAAVAJ+o+AK77yt0Q70Eq/cPocdtggVjAAABAAMAngPbIw6HwpcXzZzeQ9CqIPw+AQCQvAMGL4e6eQc18kswsdvZFAqNunJsN9zUrSelvu5PsluS5XEf4ZJBE6irjcSux0wNJFUatiKhI4Iwjjutak+qbhPh2UoIVPsZCOerZhyZj3ctZA9XkseF8dBedcvDZTXIy5bnXTeunJFWIWUompKkOEW+LsNcWz7U5FlUpRmjZTTSnaMEJZxzJkKnrKvXwr3bgQfs4HGgiXjsh5rrh81pQ+9iB4JEm+xrWKiGx7ZzECeTitSM5mAMGcbfuGgsrlZ+uyPTCcZuqnuLsviuJl8TU8zL5PEZOkcNsMbjyeSP3tCBVA08CHe5TkoAAAEADMpc4/GRIAeE07CJLuXYU95WuMGxo/7sOiENkMsNYB1SCNfKRPi1cR/0laMS7ifrVIVn7EWN4cEgc/1FBePUaV92qAbvx+NnPSowoC7R40d7Lfb4Hk+kJMbZo7vDmv/c8ttyFXxZaspklWDIeHjcdxJIIcoTRblcC4IFNqK9xAnQmz5jd0ii2RizdYa/7lfL9R0Gc8NQli3N9LLcxrnkhY9mvyqJUIvUH1kX0CWbrDOon5b9uKPEji7R9xHFbZx4biW7XcFpe53hnlFMyFTdECIw7uwl9dgQeAJQgZJDQy7Z0KlWQViw/cntZntnpM7hpkcRwo+fp+fRV21XUsNpzg==',
    keytype => 'ssh-dss',
    expire  => "2012-02-28",
    tag     => 'customer',
  }

  @account::user {'motorola':
    uid     => '21005',
    group   => 'motorola',
    comment => 'Support ticket 767',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAo/r6KjkRGGR98bTfaNAOExKFJkPTvq2RyTBPEahcm25Lj15KWsT1f4BKUJirlwqe6RerM5DU8h/Nj8WbFJioG09P79oXfJjos801tlSnyEWBxZnHk6ijwKs/R9FVRPp70JMI0BhyC6+3pJfPs71zQdpWQBFaUxTVvZaaazJm8mO0kFBOqWxoWDegf1NxYDmsBL78VAsOYwlI28FrV46LMi/gO8Y0Q1H2qFvE1iJQpeN7fx90/7GiSTsNCBhdUJZsZBSID/WzXRqCFTD5pF0e6Gm6cxz/A3HzsrT6aUgOlfI8nql3AYRG7p8HiCiXKFURCfPVfoIXay1VRo7pLEMxyw=='
    keytype => 'ssh-rsa',
    expire  => "2012-04-01",
    tag     => 'customer',
  }
}
