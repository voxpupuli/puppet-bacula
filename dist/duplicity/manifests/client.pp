class duplicity::client {

  include gpg

  package { "duplicity":
    ensure => present,
  }

}
