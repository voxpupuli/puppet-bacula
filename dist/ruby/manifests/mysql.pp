# Get the ruby bindings for mysql
class ruby::mysql {
  package {
    "libmysql-ruby": ensure => installed;
  }
}
