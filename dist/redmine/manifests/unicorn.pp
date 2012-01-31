class redmine::unicorn (
  $vhost         = 'projects.puppetlabs.com',
  $serveraliases = undef,
  $user          = 'redmine',
  $group         = 'redmine',
  $ssl           = true,
  $approot       = '/opt/redmine'
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
  unicorn::app{ 'redmine':
    approot         => $approot,
    rack_file       => 'puppet:///modules/unicorn/config.ru',
    unicorn_pidfile => "/var/run/${user}/unicorn.pid",
    unicorn_socket  => $unicorn_socket,
    unicorn_user    => $user,
    unicorn_group   => $group,
    config_file     => '/etc/unicorn_redmine_runner.rb',
    #config_template => 'redmine/unicorn.config.rb.erb',
    log_stds        => true,
    require         => File["/var/run/${user}"],
  }


  # Set some defaults for the possibly two following unicorns, just to
  # reduce repeating myself.
  Nginx::Unicorn {
    servername     => $vhost,
    serveraliases  => $serveraliases,
    unicorn_socket => $unicorn_socket,
    path           => '/opt/redmine',
  }

  # do nginx..
  # It carries the SSL, which if true, will default to port 443, so
  # and if not, will just be the default of port 80.
  #
  # We, somewhat rudely, assume that this machine _just_ does redmine.
  # So become the default vhost. Which I think is reasonable.
  nginx::unicorn {
    $vhost:
      priority       => 66,
      ssl            => $ssl,
      isdefaultvhost => true,
      template       => 'redmine/vhost-redmine-unicorn.nginx.erb',
  }

  # Rotation job, so production.log doesn't get out of control!
  logrotate::job {
    'redmine_unicorn':
      log        => '/opt/redmine/log/*.log',
      options    => ['rotate 28', 'weekly', 'compress', 'compresscmd /usr/bin/xz', 'uncompresscmd /usr/bin/unxz', 'notifempty','sharedscripts'],
      postrotate => '/etc/init.d/unicorn_redmine reopen-logs > /dev/null',
      require    => Unicorn::App['redmine'],
  }


}

define redmine::unicorn::oldshit (
    $db,
    $db_user,
    $db_pw,
    $dir,
    $port      = '80',
    $backup    = 'true',
    $webserver = 'none',
    $version   = 'UNSET'
    ) {
  include apache::params

  # more modules: ssl

  $unicorn_packages = [ 'libmysql-ruby', 'unicorn', 'i18n' ]

  include ruby::mysql

  package {
    'unicorn':       ensure => installed, provider => gem;
    'i18n':          ensure => '0.4.2',   provider => gem;
    # 'rack':          ensure => '1.1.0',   provider => gem;
    # uncomment the above ONCE we migrate redmine past 1.1.x
  }

  # Dxul, on karmic, for instance NEVER works, so lets no pretend the
  # init script is good. Lets use hasstatus if it's there, and fall
  # back to a pattern if not.
  service {
    'unicorn':
      ensure    => running,
      enable    => true,
      hasstatus => $lsbdistcodename ? {
        default  => true,
        'karmic' => false,
      },
      pattern => 'unicorn_rails master',
      require => [
        Package['unicorn'],
        File["/etc/init.d/unicorn","${dir}/${name}/config/unicorn.config.rb"]],
  }

  redmine::instance { 
    $name:
      db      => $db,
      db_user => $db_user,
      db_pw   => $db_pw, 
      user    => $apache::params::user, 
      group   => $apache::params::group, 
      dir     => $dir,
      backup  => $backup,
      version => $version,
  }

  # I promise I will make this good...
  # And I lied... -ben
  if $webserver == "apache" {

    # load the modules we use for apache to bounce connections between
    # unicorn and apache.
    a2mod { [ 'proxy', 'proxy_balancer', 'proxy_http' ]: ensure => present, }

    apache::vhost { $name:
      servername => $name,
      port       => $port,
      priority   => '30',
      ssl        => false,
      docroot    => "${dir}/${name}/public/",
      template   => 'redmine/redmine-unicorn.conf.erb',
      require    => Service['unicorn'],
    }

    apache::vhost { "${name}_ssl":
      servername => $name,
      port       => 443,
      priority   => '31',
      ssl        => true,
      docroot    => "${dir}/${name}/public/",
      template   => 'redmine/redmine-unicorn.conf.erb',
      require    => Service['unicorn'],
    }
  }

  file { "${dir}/${name}/config/unicorn.config.rb":
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Redmine::Instance[$name],
    content => template("redmine/unicorn.config.rb.erb");
  }

  file { "/etc/init.d/unicorn":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("redmine/unicorn.initscript.erb");
  }



}

