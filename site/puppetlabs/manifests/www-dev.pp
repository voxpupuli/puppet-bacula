class puppetlabs::www-dev {

  $mysql_root_pw = 'n0tInpr0duct1on'
  include mysql::server

  # Base
  include puppetlabs::lan
  include puppetlabs_ssl

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
      development     => true,
  }

  package {'php5-curl': ensure => present, notify => Service[httpd] }  

}
