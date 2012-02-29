class nagios::gearman (
    $server = false,
    $key,
    $nagios_server
  ){

  $nrpe_server = hiera("nrpe_server")
  $hostgroup = hiera("location")

  case $server {
    true: {
      $packages = [
        "gearman",
        "gearman-tools",
        "mod-gearman-doc",
        "mod-gearman-module",
        "mod-gearman-tools",
        "mod-gearman-worker",
        "gearman-job-server",
      ]
    }
    false: {
      $packages = [
        "mod-gearman-worker"
      ]
    }
    default: { }
  }

  # remove once wheezy is everywhere
  if $lsbdistcodename != "wheezy" {
    package {
      $packages:
        ensure  => installed,
        require => Apt::Source["wheezy.list"];
    }
  }

  user { "nagios":
    shell => "/bin/bash",
  }

  service { "mod-gearman-worker":
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  file { "/etc/mod-gearman/worker.conf":
    #replace => false,
    content => template("nagios/worker.conf.erb"),
    notify  => Service["mod-gearman-worker"],
    require => Package[$packages],
  }

  @@nagios_service { "check_gearman_worker_${hostname}":
    use                 => 'generic-service',
    check_command       => "check_gearman_worker!localhost!worker_${hostname}",
    host_name           => "${nagios_server}",
    service_description => "check_gearman_worker_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  # Server only stuff, only need one per site, atm
  if $server == true {
    service { "gearman-job-server":
      ensure    => running,
      enable    => true,
      hasstatus => false,
      pattern   => "gearmand",
    }

    file { "/etc/nagios3/gearman.conf":
      replace => false,
      content => template("nagios/gearman.conf.erb"),
      notify  => [Service["mod-gearman-worker"],Service["$::nagios::params::nagios_service"]],
    }

    @@nagios_service { "check_gearman_server":
      use                 => 'generic-service',
      check_command       => 'check_gearman_server!localhost',
      host_name           => "${nagios_server}",
      service_description => "check_gearman_server",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      notify              => Service[$nagios::params::nagios_service],
    }

  }

}
