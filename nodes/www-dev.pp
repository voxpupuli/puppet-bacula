node www-dev {

  include role::server

  $mysql_root_pw = 'n0tInpr0duct1on'
  include mysql::server

  ssh::allowgroup { "www-dev": }
  Account::User <| title == 'dansupinski' |>
  Account::User <| title == 'maxlynch' |>
  Account::User <| title == 'donaldseigler' |>
  Group <| title == 'www-dev' |>
  Group <| title == 'contractors' |>

  # Base
  include puppetlabs_ssl

  cron {
    'www dir perms':
      command => "/usr/bin/find /var/www/www-dev.puppetlabs.com/ -type d -print0 | xargs -o -I {} chmod 2775 {}",
      user    => root,
      minute  => '*/5';
    'www file perms':
      command => "/usr/bin/find /var/www/www-dev.puppetlabs.com/ -type f -print0 | xargs -o -I {} chmod 0664 {}",
      user    => root,
      minute  => '*/5';
    'www ownership':
      command => "/bin/chown -R www-data:www-dev /var/www/",
      user    => root,
  }

  file { "/usr/local/bin/www-sync.sh":
    owner  => root,
    group  => 0,
    mode   => 755,
    source => "puppet:///modules/puppetlabs/www-sync.sh";
  }

  file { "/usr/local/bin/wp-upgrade.sh":
    owner  => root,
    group  => 0,
    mode   => 755,
    source => "puppet:///modules/puppetlabs/wp-upgrade.sh";
  }

  wordpress::instance {
    'www-dev.puppetlabs.com':
      auth_key        => 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o',
      secure_auth_key => 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne',
      logged_in_key   => '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ',
      nonce_key       => 'P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3',
      db_user         => 'wwwdev',
      db_pw           => 'gosh-if-no-hull',
      template        => 'puppetlabs/dev_vhost.conf.erb',
      backup          => false,
      seturl          => true,
  }

  file { "/var/www/www-dev.puppetlabs.com/.htaccess":
    owner  => www-data,
    group  => www-dev,
    mode   => 644,
    source => "puppet:///modules/puppetlabs/puppetlabscom_htaccess";
  }

  file { "/var/www/www-dev.puppetlabs.com/.htpasswd":
    ensure => present,
    owner  => www-data,
    group  => www-dev,
    mode   => 644,
  }

  package {'php5-curl': ensure => present, notify => Service[httpd] }  

}

