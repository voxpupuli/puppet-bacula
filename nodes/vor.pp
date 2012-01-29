node vor {
  include role::server

  include postgres::install::debian

  postgres::enable{ "host": }
  postgres::config{ "host": listen => "*", }
  # Allow postgres access from the office LAN.
  postgres::hba { "host": allowedrules => [ "host    all all    192.168.100.0/23  md5", ], }

  postgres::createuser{
    'superduperuser':
      createdb  => true,
      superuser => true,
      passwd    => 'bethChivva',
  }
}
