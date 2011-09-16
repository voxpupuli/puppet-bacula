node shell {
  include role::server
  ssh::allowgroup { "allstaff": }
  include account::master
}

