class apt {

  case $operatingsystem {
    debian,ubuntu: {

      $apt_dir = "/etc/apt"
      $sources_dir     = "${apt_dir}/sources.list.d"
      $aptconf_dir     = "${apt_dir}/apt.conf.d"
      $preferences_dir = "${apt_dir}/preferences.d"

      $apt_update_ensure = $lsbdistcodename ? {
        default => present,
        karmic  => absent, # NO UPDATES FOR KARMIC
      }

      exec {
        "apt-get update":
          user        => root,
          command     => "/usr/bin/apt-get -qq update",
          refreshonly => true;
      }

      cron { "apt-get update":
        ensure  => $apt_get_update_ensure,
        command => "/usr/bin/apt-get -qq update",
        user    => root,
        minute  => 20,
        hour    => 1,
      }

      file {
        "sources.list.d":
          path    => "${sources_dir}",
          ensure  => directory,
          recurse => true,
          purge   => true,
          owner   => root,
          group   => root,
          mode    => 0755;
        "${apt_dir}/sources.list":
          ensure => absent;
      }

      file {
        "apt.conf.d":
          path    => "${aptconf_dir}",
          ensure  => directory,
          owner   => root,
          group   => root,
          mode    => 0755;
        "${apt_dir}/apt.conf":
          ensure => absent;
      }

      file {
        "preferences.d":
          path    => "${preferences_dir}",
          ensure  => directory,
          recurse => true,
          purge   => true,
          owner   => root,
          group   => root,
          mode    => 0755;
      }

    }
    default: {
      err("apt_defaults class is for Debian-derived systems.")
      err("${fqdn} runs ${operatingsystem}.")
    }
  }

}

