define mrepo::repo (
  $ensure = "present",
  $repotitle,
  $release,
  $arch,
  $metadata = 'repomd',
  $rhn      = false,
  $iso      = '',
  $updates  = '',
  $extras   = '',
  $fasttrack = ''
) {

  include mrepo::settings
  include mrepo

  case $ensure {
    present: {
      file { "${mrepo::settings::srcroot}/$name":
        ensure  => directory,
        recurse => false,
        backup  => false,
        owner   => root,
        group   => root,
        mode    => '0755',
      }

      file { "${mrepo::settings::wwwroot}/$name":
        ensure  => directory,
        recurse => false,
        backup  => false,
        owner   => root,
        group   => root,
        mode    => '0755',
      }

      file { [
      "${mrepo::settings::wwwroot}/$name/RPMS.updates",
      "${mrepo::settings::wwwroot}/$name/RPMS.all",
      ]:
        ensure  => directory,
        recurse => false,
        backup  => false,
        owner   => root,
        group   => root,
        mode    => '0755',
        require => File["${mrepo::settings::wwwroot}/$name"],
      }

      file { "/etc/mrepo.conf.d/$name.conf":
        ensure  => present,
        content => template("mrepo/repo.conf.erb"),
        require => File['/etc/mrepo.conf.d'],
      }

      if $rhn {
        exec { "Generate systemid":
          path  => "/bin:/usr/bin",
          command => "gensystemid -u ${mrepo::settings::rhn_username} -p ${mrepo::settings::rhn_password} --release $release --arch $arch ${mrepo::settings::srcroot}/$name",
          creates => "${mrepo::settings::srcroot}/$name/systemid",
        }
      }
    }
    absent: {
      file {
        "/etc/mrepo.conf.d/$name":
          backup  => false,
          recurse => false,
          force   => true,
          ensure  => absent;
        "${mrepo::settings::srcroot}/$name":
          backup  => false,
          recurse => false,
          force   => true,
          ensure  => absent;
        "${mrepo::settings::wwwroot}/$name":
          backup  => false,
          recurse => false,
          force   => true,
          ensure  => absent;
      }
    }
    default: {
      err("Unknown ensure value for mrepo::repo: $ensure")
    }
  }
}
