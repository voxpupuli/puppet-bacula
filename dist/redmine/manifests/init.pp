# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# I think I need to change this to download the latest version from git
#
class redmine (
    $vhost         = 'projects.puppetlabs.com',
    $ssl           = true,
    $newrelic      = true,
    $git_revision  = 'b618a083c23f391073aa64cf1eb3a56e14b1efef',
    $github_url    = 'git@github.com:puppetlabs/redmine.git',
    $user          = 'redmine',
    $group         = 'redmine',
    $appserver     = 'unicorn',
    $approot       = '/opt/redmine',
    $db            = 'redmine',
    $serveraliases = undef
) {


  include ruby::dev

  motd::register { "A Redmine tracker at ${vhost}": }

  # If we're deploying from github we may need our deploy keys to do
  # that. Or git/puppet hangs indefinitely.
  if $github_url == 'git@github.com:puppetlabs/redmine.git' {
      include redmine::sshkey
  }

  # TODO
  # need to update the environment.rb with correct version of rails

  # Libs needed for bundler gems below
  $gem_deps = [
    "libmagickwand-dev",
    "libmysqlclient-dev",
  ]

  package { $gem_deps: ensure => installed; }

  $rails_version = hiera('rails_version')
  require rails
  require git

  bundler::bundle { "${approot}/Gemfile":
    source => ':rubygems',
    gems   => {
      "rails"               => '2.3.14',
      "rack"                => '1.1.3',
      "rake"                => '0.8.7',
      "rubytree"            => '0.8.2',
      "newrelic_rpm"        => '3.3.1',
      "coderay"             => '0.9.8',
      "mysql"               => '2.8.1',
      "rdiscount"           => '1.6.8',
      "inherited_resources" => '1.0.6',
      "rmagick"             => '2.13.1',
      "ruby-openid"         => '2.1.8',
    },
    require => Package[$gem_deps],
  }

  package {
    'i18n': ensure => '0.4.2', provider => gem;
  }

  # This relies on the host in question having bacula class
  if defined( Class['bacula'] ) {
    bacula::job {
      "${fqdn}-redmine":
        files => [$approot],
    }
  }

  if defined( Class['nagios'] ) {
    nagios::website { $vhost: }
  }

  user { $user:
    ensure   => present,
    gid      => $group,
    password => '*',
    system   => true,
    comment  => 'Puppet Labs Russian Ore',
    shell    => '/bin/nologin',
  }

  group { $group: ensure => present }

  file { '/opt/':
    owner  => 'root',
    ensure => directory,
  }

  vcsrepo { $approot:
    source   => $github_url,
    provider => git,
    revision => $git_revision,
    owner    => $user,
    group    => $group,
    ensure   => present,
    require  => [
            User[$user],
           Group[$group],
            File['/opt/'],
           Class['ruby::dev'],
           Class['redmine::sshkey']
    ]
  }

  file{ "${approot}/config/configuration.yml":
    source => 'puppet:///modules/redmine/configuration.yml',
    owner   => $user,
    group   => $group,
    ensure  => present,
    before  => Class['redmine::unicorn'],
    require => Vcsrepo[$approot],
  }

  if $newrelic == true {
      file { "${approot}/config/newrelic.yml":
        owner   => $user,
        group   => $group,
        ensure  => present,
        source  => 'puppet:///modules/redmine/newrelic.yml',
        require => [ Vcsrepo[$approot], Package['newrelic_rpm'] ],
      }

      package { 'newrelic_rpm':
        ensure   => present,
        provider => gem,
        require  => Vcsrepo[$approot],
      }

      # The cheeky unicorn hack script from
      # http://newrelic.com/docs/discussions/2909-unicorn-without-preload_app-with-rails
      file{ "${approot}/config/initializers/unicorn_preloader.rb":
        owner   => $user,
        group   => $group,
        ensure  => present,
        source  => 'puppet:///modules/redmine/unicorn_preloader.rb',
        before  => Class['redmine::unicorn'],
        require => [ Vcsrepo[$approot], Package['newrelic_rpm'] ],
      }

  }

  file { [ "${approot}/tmp", "${approot}/log", "${approot}/files"]:
    owner   => $user,
    group   => $group,
    ensure  => directory,
    mode    => '0755',
    require => Vcsrepo[$approot],
  }

  case $appserver {
    'unicorn': {
      class{ 'redmine::unicorn':
        vhost         => $vhost,
        serveraliases => $serveraliases,
        ssl           => $ssl,
        require       => Vcsrepo[$approot],
        approot       => $approot,
      }
    }
  }

  ####################
  # Database setup
  ####################

  $db_user = $user
  $db_pw = hiera('redmine_db_pw')

  # database crap
  mysql::db { $name:
    db_user => $db_user,
    db_pw   => $db_pw,
    before  => Exec["${name}-session"],
  }

  require mysql::ruby
  include mysql::params

  file { "${approot}/config/database.yml":
    content => template('redmine/database.yml.erb'),
    require => Vcsrepo["${approot}"]
  }

  Exec { logoutput => on_failure, path => '/usr/bin:/bin' }

  exec { "${name}-session":
    command     => '/usr/bin/rake config/initializers/session_store.rb',
    environment => 'RAILS_ENV=production',
    cwd         => $approot,
    creates     => "${approot}/config/initializers/session_store.rb",
    require     => Class['rails'],
  }

  exec { "${name}-migrate":
    command     => '/usr/bin/rake db:migrate',
    cwd         => "${approot}",
    environment => 'RAILS_ENV=production',
    creates     => "${approot}/db/schema.rb",
    require     => Exec["${name}-session"],
  }

  if $redmine_default_data {
    exec{"${name}-default":
      command     => '/usr/bin/rake redmine:load_default_data',
      cwd         => $approot,
      environment => 'RAILS_ENV=production',
      require     => Exec["${name}-migrate"],
    }
  }

  file {
    [ "${approot}/public", "${approot}/public/plugin_assets" ]:
      ensure  => directory,
      #recurse => true,
      owner   => $user,
      group   => $group,
      mode    => '0755',
      require => Exec["${name}-migrate"],
  }

  ####################
  # Maintenance
  ####################

  file { '/usr/local/bin/redmine_permission_keeper.sh':
      owner   => root,
      group   => $group,
      mode    => 0750,
      content => template("redmine/permission_keeper.sh");
  }

  file{ '/usr/local/sbin/cron_imap_runner.sh':
    source => 'puppet:///modules/redmine/cron_imap_runner.sh',
    owner  => root,
    group  => $group,
    mode   => 0750,
  }

  cron {
    "redmine_tickets_email":
      user    => $user,
      minute  => "*/10",
      command => '/usr/local/sbin/cron_imap_runner.sh all';

  #    "Redmine: permission_keeper.sh":
  #      command => "/usr/local/bin/redmine_permission_keeper.sh",
  #      user    => root,
  #      minute  => "*/15",
  #      require => File["/usr/local/bin/redmine_permission_keeper.sh"];
  #    # recursion file type makes for huge reports + checksumming when we just care about perms
  #    "redmine_files_and_tmp_permissions":
  #      command => "/usr/bin/find /opt/redmine/files /opt/redmine/tmp -exec chown ${user}:${group} {} ; /usr/bin/find /opt/redmine/files /opt/redmine/tmp -exec chmod 755 {};",
  #      user    => root,
  #      ensure  => absent,
  #      minute  => "*/15";
  #    # recursion file type makes for huge reports
  #    "redmine_public_and_log_permissions":
  #      command => "/usr/bin/find /opt/redmine/public /opt/redmine/log -exec chown ${user}:${group} {} ; /usr/bin/find /opt/redmine/public /opt/redmine/log -exec chmod 755 {}",
  #      user    => root,
  #      ensure  => absent,
  #      minute  => "*/15";
  }

}
