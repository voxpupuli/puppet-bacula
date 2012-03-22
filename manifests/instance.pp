# = Class: gitolite::instance
#
# == Purpose
#
# This class creates a gitolite instance and the necessary prerequisite files
#
# == Parameters
#
# The following variables are pulled from hiera.
#
# * gitolite_instance_manage_user   - Whether or not to manage the gitolite user
# * gitolite_instance_user          - The name of the gitolite user
# * gitolite_instance_group         - The name of the gitolite group
# * gitolite_instance_home          - The name of the gitolite home directory
# * gitolite_instance_key           - The full ssh public key to use to initialize the gitolite-admin repo.
#
class gitolite::instance(
  $manage_user = hiera('gitolite_instance_manage_user'),
  $key         = hiera('gitolite_instance_key')
){

  require gitolite::install

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
