node shell {
  include role::server
  include account::master
  include apt::backports
  ssh::allowgroup { "allstaff": }

  apt::source { "http://ppa.launchpad.net/schwuk/znc/ubuntu": }

}

