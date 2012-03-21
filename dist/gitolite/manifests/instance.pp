class gitolite::instance(
  $manage_user = hiera('gitolite_instance_manage_user'),
  $key         = hiera('gitolite_instance_key')
){

  require gitolite::package

  $user  = hiera('gitolite_instance_user')
  $group = hiera('gitolite_instance_group')
  $home  = hiera('gitolite_instance_home')

  $gitolite_initial_key = "${home}/admin.pub"

  if $manage_user == true {
    group { $group:
      ensure => present,
      before => User[$user],
    }

    user { $user:
      ensure     => present,
      gid        => $group,
      home       => $home,
      managehome => true,
      comment    => 'Gitolite system account',
    }

  }

  file { $gitolite_initial_key:
    ensure  => present,
    content => $key,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    require => $manage_user ? {
      true    => User[$user],
      default => undef,
    },
  }

  exec { "gl-setup ${gitolite_initial_key} -q":
    path        => ["/usr/bin", "/bin"],
    environment => ["HOME=${home}"],
    user        => $user,
    group       => $group,
    logoutput   => on_failure,
    creates     => "${home}/.gitolite",
    require     => File[$gitolite_initial_key],
  }
}
