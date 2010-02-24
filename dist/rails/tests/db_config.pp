# this should probably be a file fragment for managing multi environments
$dir = '/tmp/test'
file{$dir:
  ensure => directory,
}
file{"${dir}/config":
  ensure => directory,
}
rails::db_config{$dir:
  username => 'redmine',
  password => 'redmine',
  database => 'redmine',
  require => File["${dir}/config"],
}
