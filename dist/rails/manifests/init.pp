class rails {
<<<<<<< HEAD:dist/rails/manifests/init.pp
  include 'ruby'
  include 'mysql::server' #Not going to configure database yet.  Perhaps write a native resource type for mysql.
  package { ['libmysqld-dev', 'libmysqlclient15-dev']: ensure => 'installed' }
  package { ['rails', 'mysql']: ensure => installed,  provider => gem, require => [ Class['mysql::server'], Class['ruby'] ] }
=======
  require 'ruby::dev'
  if !$rails_version {
    fail('$rails_version must be defined when rails is included')
  }
  # this will not work if gems was not installed 
  # on a previous run
  package{'rails':
    ensure   => $rails_version,
    provider => 'gem',
  }
  
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/rails/manifests/init.pp
}
