#installs the ruby bindings for mysql
class mysql::ruby {
  # I am not making the mysql package a dep for this
  # the only dep is the package which yum will resolve for me.
  package{'ruby-mysql':
    ensure => installed,
  }
}
