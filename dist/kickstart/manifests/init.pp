class kickstart {
  include kickstart::params

  file { $kickstart::params::ks_root:
    ensure => directory,
    owner  => $kickstart::params::ks_user,
    group  => $kickstart::params::ks_group,
    mode   => '755',
  }
}
