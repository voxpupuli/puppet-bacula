node 'wordtodapress' {

  class{ 'role::server':
    nagios => false,
    bacula => false,
    munin  => false,
  }

  $mysql_old_pw = ''
  $mysql_root_pw = 'jvepngI,'

  #   $bacula_director = 'baal.puppetlabs.com'
  #   $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  #   class { "bacula":
  #     director => $bacula_director,
  #     password => $bacula_password,
  #   }
  # 
  include mysql::server

  package {'php5-curl': ensure => present }

  wordpress::instance {
    'markops.puppetlabs.lan':
      site_alias      => "www.markops.puppetlabs.lan",
      auth_key        => 'uspk1YxmxcUDIqhjH1pUQq59WCTvISTXlflU7UZoUFw8faCzNy1VC8Uq9sl0gxg',
      secure_auth_key => 'uJQKXGrbtSs4toOG2JsqjrYopYU9Ij9wQYX5kttycvTwEfc9uGFDxo6leeLCITL',
      logged_in_key   => 'u7O5y1MW41ZT4jETgJkdCUn35f8fzQgfnZ9sivR4k8M5kU6U17I6GhA73NtLVLd',
      nonce_key       => 'ueRyvF7pScI6OAhGQaDaSgNnXsKBkutqshJxc2a4PRmXEDEVzNarEYJenhvDQIq',
      db_pw           => 'pNuTJEkV9vip',
      db_user         => 'markopsplabs',
      template        => 'puppetlabs/markopspuppetlabs_vhost.conf.erb',
      priority        => '02',
      seturl          => true,
      port            => 80,
      backup          => false,
  }

  vcsrepo{
    '/var/www/markops.puppetlabs.lan/wp-content/themes/puppetlabs':
      source   => 'git@github.com:puppetlabs/puppetlabs-wordpress-theme.git',
      provider => 'git',
      ensure   => latest,
      revision => 'HEAD',
      notify   => Apache::Vhost['markops.puppetlabs.lan'],
  }

}
