# set all of the default parameters for resources

# set up the default filebucket
Filebucket { main: server => $servername }
# set the default owner for files
File {
  backup => main,
  owner  => root,
  group  => root,
  mode   => 0644,
}
# do not manage packages until yum client is setup
Package {
  require => Class["yum"],
  ensure => latest,
}

Exec{
  path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
}
