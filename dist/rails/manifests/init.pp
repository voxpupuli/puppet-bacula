class rails {
  include 'ruby'
  include 'mysql::server' #Not going to configure database yet.  Perhaps write a native resource type for mysql.
  package { ['libmysqld-dev', 'libmysqlclient15-dev']: ensure => 'installed' }
  package { ['rails', 'mysql']: ensure => installed,  provider => gem, require => [ Class['mysql::server'], Class['ruby'] ] }
}
