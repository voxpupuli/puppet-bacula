#
# I generated these keys, from the following url
# https://api.wordpress.org/secret-key/1.1/
#
$mysql_root_pw='password'
wordpress::instance{'puppet-ubuntu':
  db => 'wordpress',
  db_user => 'wordpress',
  db_pw => 'wordpass',
  auth_key => 'PE{TEN%T).U~V6Cl;b_?0mcrvhoUVIP#+0R|e-LB>00:o*((b%[8pve/1Y+H}P(o', 
  secure_auth_key => 'PDqD)bN|B22D.hxk@Uvy;nkT0#9QVB8=~J^r3@9f:7gRn9PmNGBth(t2+hLt|=Ne', 
  logged_in_key => '#_Y3SS3oBj(<ja{dW+#fE!{=YhoiP<0@m~e)Gp[d0j5x1OxGAAFjl|3yHzmH{srZ', 
  nonce_key =>'P,>pH-J+OTw#z2qn`M[lt||`[Nf|w#I:J %z>-MRY@Yt_Egyj84znb2H*s;0J||3',
}
