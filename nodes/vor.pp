node vor {
  include role::server
  include apt::backports
  # This is dirty and a lot of the above should be moved to this
  # class.
  include postgres::install::debian

  postgres::enable{ "host": }
  postgres::config{ "host": listen => "*", }
  # Allow postgres access from the office LAN.
  postgres::hba { "host": allowedrules => [ "host    all all    192.168.100.0/24  md5", ], }

  postgres::createuser{
    'superduperuser':
      createdb  => true,
      superuser => true,
      passwd    => 'bethChivva',
  }
}
