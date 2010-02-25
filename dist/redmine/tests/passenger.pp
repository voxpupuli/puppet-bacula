# you may have to specify an old mysql pw if you borked /root/.my.cnf
#$mysql_old_pw='redmine'
# this needs to be moved somewhere else, but I am a little confused by the scoping??
$mysql_root_pw='password'
file{'/opt/redmine':
  ensure => directory,
}
redmine::passenger{'puppet-ubuntu':
  db      => 'redmine1',
  db_user => 'redmine',
  db_pw => 'password',
  dir => '/opt/redmine', 
  port => '80',
}
redmine::passenger{'puppet-ubuntu2':
  db      => 'redmine2',
  db_user => 'redmine2',
  db_pw => 'password2',
  dir => '/opt/redmine', 
  port => '81',
}
redmine::passenger{'puppet-ubuntu5':
  db      => 'redmine5',
  db_user => 'redmine3',
  db_pw => 'password3',
  dir => '/opt/redmine', 
  port => '82',
}
