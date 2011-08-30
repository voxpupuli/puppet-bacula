class puppetlabs::vor {

  # This is dirty and a lot of the above should be moved to this
  # class.
  include postgres::install::debian

  # class{ 'postgres':
  #   require => Package['postgresql-9.0']
  # }

  postgres::user{ 'superduperuser':
    createdb  => true,
    superuser => true,
  }

  postgres::hba{ 'superduperuser':
    type     => 'user',
    database => 'ALL',
    cidr     => '192.168.100.0/24',
    method   => 'MD5',
  }

}

