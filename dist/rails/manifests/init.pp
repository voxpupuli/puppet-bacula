class rails {
  include 'ruby'
  include 'mysql::server'
  package {["rubygem-rails","ruby-mysql"]: ensure => installed, require => [ Class['mysql::server'], Class['ruby'] ] }
}
