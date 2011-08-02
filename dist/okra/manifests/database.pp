# Class okra::database
# 
# Creates the okra database
class okra::database {
  include okra::params
  $user     = $okra::params::user
  $group    = $okra::params::group
  $password = 'f3kh7b21'

  package { ["mysql-client", "mysql-server"]:
    ensure => present,
  }

  service { "mysql":
    ensure => running,
    enable => true,
  }
  file { "${okra::params::basedir}/config/database.yml":
    ensure => present,
    owner  => $okra::params::user,
    group  => $okra::params::group,
    mode   => '0640',
    content => template("okra/database.yml.erb"),
  }
}
