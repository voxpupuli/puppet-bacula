class puppetlabs::web01 {

  $mysql_root_pw = 'K7DkG9TVfGke'
  include mysql::server

  wordpress::instance {
    'madstop.com':
      site_alias      => "www.madstop.com",
      auth_key        => 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o',
      secure_auth_key => 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne',
      logged_in_key   => '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ',
      nonce_key       => 'P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3',
      db_pw           => 'illYZbw108Ckle8Q',
      template        => 'puppetlabs/madstop_vhost.conf.erb',
  }

  wordpress::instance {
    'puppetlabs.com':
      site_alias      => "www.puppetlabs.com",
      auth_key        => 'rspk1YxmxcUDIqhjH1pUQq59WCTvISTXlflU7UZoUFw8faCzNy1VC8Uq9sl0gxg',
      secure_auth_key => 'MJQKXGrbtSs4toOG2JsqjrYopYU9Ij9wQYX5kttycvTwEfc9uGFDxo6leeLCITL',
      logged_in_key   => 't7O5y1MW41ZT4jETgJkdCUn35f8fzQgfnZ9sivR4k8M5kU6U17I6GhA73NtLVLd',
      nonce_key       => 'ReRyvF7pScI6OAhGQaDaSgNnXsKBkutqshJxc2a4PRmXEDEVzNarEYJenhvDQIq',
      db_pw           => '5NuTnEFV9Hvp',
      db_user         => 'plabs',
      template        => 'puppetlabs/puppetlabs_vhost.conf.erb',
  }

  wordpress::instance {
    'puppetdevchallenge.com':
      site_alias => "www.puppetdevchallenge.com",
      db_pw      => 'az62VHwUbtCi',
      db_user    => 'pdchallange',
      template   => 'puppetlabs/wordpress_vhost.conf.erb',
  }

  wordpress::instance {
    'puppetcon.com':
      site_alias => "www.puppetcon.com",
      db_pw      => 'TiR6znV9EmGj',
      db_user    => 'pcon',
      template   => 'puppetlabs/wordpress_vhost.conf.erb',
  }


}
