node shell {
  include role::server
  include account::master
  include apt::backports
  ssh::allowgroup { "allstaff": }

}

