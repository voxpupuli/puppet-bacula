class puppetlabs::wordpress {
  # install DB
  # get sql file 
  file{'/tmp/wordpress.sql':
    source => 'puppet:///modules/puppetlabs/puppetlabs_dev_2010-03-12.sql'
  }
  # create db and import data
  mysql::db{"puppetlabs":
    db_user => 'puppetlabs',
    db_pw   => 'Pupp3tR0cks',
    sql => '/tmp/wordpress.sql',
    require => File['/tmp/wordpress.sql'],   
  }
  # install wordpress
  require wordpress
  Exec{path => '/usr/bin:/bin'}
  $vhost_dir = "/opt/puppetlabs"
  file{$vhost_dir:
    ensure => directory,
  } 
  file{'/tmp/wordpress.zip':
    source => 'puppet:///modules/puppetlabs/blog.puppetlabs.com.zip',
  }
  exec{'unzip-puppetlabs':
    cwd => $vhost_dir,
    require => File['/tmp/wordpress.zip'],
    command => "unzip /tmp/wordpress.zip",
    logoutput => on_failure,
  }
  $auth_key = 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o'
  $secure_auth_key = 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne'
  $logged_in_key = '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ'
  $nonce_key ='P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3'

  file{"${app_dir}/wp-config.php":
    content => template('wordpress/wp-config.php.erb'),
  }
  apache::vhost{'puppelabs':
    port    => 80,
    docroot => $app_dir,
    webdir  => $app_dir,
  }
}
 
