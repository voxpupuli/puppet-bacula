define duplicity::drop ($owner) {

  include duplicity::params

  file { "${duplicity::params::droproot}/${name}":
    ensure => directory,
    owner  => $owner,
    group  => "root",
    mode   => "0700",
  }
}
