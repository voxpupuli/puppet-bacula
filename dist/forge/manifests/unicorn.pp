# Unicorn app server, talking to forge's code. What could go wrong.

class forge::unicorn(
  $vhost         = 'forge.puppetlabs.com',
  $serveraliases = undef,
  $user          = 'forge',
  $group         = 'forge',
  $ssl           = true
) {

  include nginx::server

  file{ "/var/run/${user}":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  $unicorn_socket = "/var/run/${user}/unicorn.sock"

  # Use the dashboard rack file, as it turns out it's generic.
  # The config_file needs to be outside of the approot, as it's run by
  # root having it writable means you can change it, cause the app to
  # die and then probably get root.
  unicorn::app{ 'forge':
    approot         => '/opt/forge',
    rack_file       => 'puppet:///modules/unicorn/dashboard_config.ru',
    unicorn_pidfile => "/var/run/${user}/unicorn.pid",
    unicorn_socket  => $unicorn_socket,
    unicorn_user    => $user,
    unicorn_group   => $group,
    config_file     => '/etc/unicorn_forge_runner.rb',
    log_stds        => true,
    require         => File["/var/run/${user}"],
  }


  # Set some defaults for the possibly two following unicorns, just to
  # reduce repeating myself.
  Nginx::Unicorn {
    servername     => $vhost,
    serveraliases   => $serveraliases,
    unicorn_socket => $unicorn_socket,
    path           => '/opt/forge',
  }

  # do nginx..
  nginx::unicorn {
    $vhost:
      port           => 80,
      priority       => 66,
  }

  # would it be more intelligent to make a "ssl => both" option in
  # nginx::unicorn?
  if $ssl == true {
    nginx::unicorn {
      "${vhost}_ssl":
        port           => 443,
        priority       => 55,
        ssl            => true,
    }
  }

  # Rotation job, so production.log doesn't get out of control!
  logrotate::job {
    'forge_unicorn':
      log        => '/opt/forge/log/*.log',
      options    => ['rotate 28', 'weekly', 'compress', 'compresscmd /usr/bin/xz', 'uncompresscmd /usr/bin/unxz', 'notifempty','sharedscripts'],
      postrotate => '/etc/init.d/unicorn_forge reopen-logs > /dev/null',
      require    => Unicorn::App['forge'],
  }


}
