node xaman {

  include role::server

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "developers": }
  ssh::allowgroup   { "interns": }

  sudo::entry {
    "randall-okra":
      entry => "randall ALL = (okra) NOPASSWD: ALL";
    "pvande-okra":
      entry => "pvande  ALL = (okra) NOPASSWD: ALL";
  }

  include puppetlabs_ssl
  include okra::passenger
}
