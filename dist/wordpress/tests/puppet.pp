# first move files to /tmp
$db = puppetlabs
$db_pw='Pupp3tR0cks'
$db_user='puppetlabs'
$mysql_root_pw='password'

  # install DB
  # get sql file 
  # create db and import data
  mysql::db{"puppetlabs":
    db_user => 'puppetlabs',
    db_pw   => 'Pupp3tR0cks',
    sql => '/tmp/puppetlabs_dev_2010-03-12.sql',
  }
  # install wordpress
  require wordpress
  Exec{path => '/usr/bin:/bin'}
  $vhost_dir = "/opt/puppetlabs"
  $app_dir="${vhost_dir}/blog.puppetlabs.com/wordpress"
  file{$vhost_dir:
    ensure => directory,
  } 
  exec{'unzip-puppetlabs':
    cwd => $vhost_dir,
    command => "unzip /tmp/blog.puppetlabs.com.zip",
    logoutput => on_failure,
    creates => "${vhost_dir}/blog.puppetlabs.com",
  }
  $auth_key = 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o'
  $secure_auth_key = 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne'
  $logged_in_key = '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ'
  $nonce_key ='P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3'

  file{"${app_dir}/wp-config.php":
    content => template('wordpress/wp-config.php.erb'),
    require => Exec['unzip-puppetlabs'],
  }
  apache::vhost{'puppet-ubuntu2':
    port    => 80,
    docroot => $app_dir,
    webdir  => $app_dir,
    require => File["${app_dir}/wp-config.php"],
  }
 
