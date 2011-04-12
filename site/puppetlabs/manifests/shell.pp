# Class: puppetlabs::enkal
#
# This class installs and configures Shell
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::shell {
	ssh::allowgroup { "allstaff": }
  #ssh::allowgroup { "hudson": }

  # Mysql
#  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4a1'
#  include mysql::server

  # Base
  include puppetlabs
  include account::master
  include firewall

  include pkgs::admin
  #include apache

  include munin
  include munin::puppet
	
	# Collectd
	include collectd::client

  #$bacula_director = 'baal.puppetlabs.com'
  #$bacula_password = 'aNXF2C1LFdptETvihkk/z'
  #include bacula

  #include postfix
#  wordpress::instance {
#    'dev.puppetlabs.com':
#      auth_key        => 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o',
#      secure_auth_key => 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne',
#      logged_in_key   => '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ',
#      nonce_key       => 'P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3',
#      db_pw           => 'not-gosh-if-no-hull',
#      template        => 'puppetlabs/dev_vhost.conf.erb',
#      backup          => false,
#      development     => true,
#  }
#  package {'php5-curl': ensure => present, notify => Service[httpd] }
#  #realize(A2mod['headers'])
#  #realize(A2mod['expires'])
#
#  mysql::db{"bbpress":
#    db_user => 'bbpress',
#    db_pw => 'alskjdasidjLKLKJoiajksldmalskjLIJSd817238172u',
#  }

}

