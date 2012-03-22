# = Class: gitolite::install
#
# Backports requires the backports repo available. Fo shizzle.
class gitolite::install($source = hiera('gitolite_install_source')) {

  case $source {
    'backports': {
      apt::force { 'gitolite':
        release => 'squeeze-backports',
      }
    }
    'git': {
      $user  = hiera('gitolite_instance_user')
      $group = hiera('gitolite_instance_group')
      $home  = hiera('gitolite_instance_home')

      # Variable munging
      $home_env = "HOME=${home}"
      $bashrc = "${home}/.bashrc"

      exec { 'clone gitolite source':
        command     => 'git clone git://github.com/sitaramc/gitolite gitolite-src',
        path        => ['/usr/bin', '/bin', '/usr/local/bin', '/opt/local/bin'],
        user        => $user,
        group       => $group,
        cwd         => $home,
        environment => $home_env,
        creates     => "${home}/gitolite-src",
      }

      exec { "install gitolite into ${home}":
        command     => "${home}/gitolite-src/src/gl-system-install",
        logoutput   => on_failure,
        user        => $user,
        group       => $group,
        environment => $home_env,
        creates     => "${home}/share/gitolite",
        require     => Exec['clone gitolite source'],
        returns     => [0,2], # The installer may return two
      }

      exec {'add gitolite to path':
        command   => "echo 'PATH=\$PATH:${home}/bin' >> ${bashrc}",
        path        => ['/usr/bin', '/bin', '/usr/local/bin', '/opt/local/bin'],
        logoutput => on_failure,
        user      => $user,
        group     => $group,
        unless    => "grep 'PATH=\$PATH:${home}/bin' ${bashrc}",
        require   => Exec["install gitolite into ${home}"],
        returns   => [0,2], # The installer may return two
      }
    }
    'package': {
      package { 'gitolite':
        ensure => present,
      }
    }
    default: {
      fail("${module_name} was passed a source of ${source}, expected one of [backports, git, package]")
    }
  }
}
