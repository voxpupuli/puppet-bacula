node vanir {
  include role::server
  class { "apt-cacher": }

}

