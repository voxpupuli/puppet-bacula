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
    rack_file       => 'puppet:///modules/unicorn/config.ru',
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
  # It carries the SSL, which if true, will default to port 443, so
  # and if not, will just be the default of port 80.
  # We also redirect HTTP to HTTPS if we're doing SSL, so we have some
  # security!
  #
  # We, somewhat rudely, assume that this machine _just_ does forge.
  # So become the default vhost. Which I think is reasonable.

  if $ssl == true {
    nginx::vhost::redirect{
      'forge_to_ssl':
        servername => 'forge.puppetlabs.com',
        priority   => 77,
        port       => 80,
        ssl        => false,
        dest       => 'https://forge.puppetlabs.com/',
    }
  }

  nginx::unicorn {
    $vhost:
      priority       => 66,
      ssl            => $ssl,
      isdefaultvhost => true,
      sslonly        => $ssl,   # reuse $ssl, as we can.
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
