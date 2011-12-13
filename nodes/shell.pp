node shell {
  include role::server
  include account::master
  include apt::backports
  ssh::allowgroup { "allstaff": }

  apt::source { "schwuk_ppa.list": uri => "http://ppa.launchpad.net/schwuk/znc/ubuntu", }

}

