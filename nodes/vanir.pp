node vanir {
  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  include role::server
  class { "apt-cacher": }

}

