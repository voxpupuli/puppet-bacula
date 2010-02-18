class redmine::webbrick {
  include redmine
  $redmine_port='3000'
  exec{'start-redmine':
    command => 'ruby script/server webrick -e production &',
    unless  => "netstat -ltn | grep ${redmine_port}",
    cwd     => $reddir,
    user    => 'redmine',
    require  => Class['redmine'],
  }
}
