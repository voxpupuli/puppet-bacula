class sinatra {

  require ruby

  package { "sinatra":
    ensure => present,
    provider => gem,
  }
}
