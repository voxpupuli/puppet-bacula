# Class: forge
#
# This class installs and configures parameters for Puppet Forge
# 
# Hard codes the path to /opt/forge.
#
# Parameters:
#
# Actions:
#
# Requires:
# - Ruby::Dev
# - Vcsrepo
# - forge::params
#
# Sample Usage:
#
#
#
# This git_revision SHA seems arbitary, and is of when the switch over to
# the box happened. First working known good.
#
class forge(
    $vhost         = 'forge.puppetlabs.com',
    $ssl           = true,
    $newrelic      = true,
    $do_ssh_keys   = false,
    $git_revision  = '6971a82bb7334c04587fa64a1bb8312158f8f185',
    $github_url    = 'git@github.com:puppetlabs/puppet-forge.git',
    $user          = 'forge',
    $group         = 'forge',
    $appserver     = 'unicorn',
    $serveraliases = undef
) {

  # this is needed before all the gems to build. So if we install it
  # before the vcsrepo, that should fit nicer in to the dependancy
  # graph.
  include ruby::dev

  motd::register{ "A Forge at ${vhost}": }

  # If we're deploying from github we may need our deploy keys to do
  # that. Or git/puppet hangs indefinitely.
  if $do_ssh_keys == true or $github_url == 'git@github.com:puppetlabs/puppet-forge.git' {
      include forge::sshkey
  }

  $rails_version='2.3.14'
  require rails

  # This relies on the host in question having bacula class
  if defined( Class['bacula'] ) {
    bacula::job {
      "${fqdn}-forge":
        files    => ['/opt/forge'],
    }
  }

  user{ $user:
    ensure   => present,
    gid      => $group,
    password => '*',
    system   => true,
    comment  => 'Puppet Labs Blacksmith',
  }

  group{ $group: ensure => present }


  file { '/opt/':
    owner => 'root',
    ensure => directory,
  }

  cron {
    "/opt/forge_permissions": # recursion file type makes for huge reports
      command     => "find /opt/forge -not -path '*/.git/*' -and -not -iname .git -not \\( -user ${user} -and -group ${group} \\)  -print0 | xargs --no-run-if-empty --null chown ${user}:${group}",
      environment => 'PATH=/bin:/usr/bin',
      user        => root,
      minute      => "*/30";
  }

  # repo. require ruby::dev explicitly.
  vcsrepo { '/opt/forge':
    source   => $github_url,
    provider => git,
    revision => $git_revision,
    owner    => $user,
    group    => $group,
    ensure   => present,
    require => [ User[$user], Group[$group], File['/opt/'], Class['ruby::dev'] ]
  }

  file { '/opt/forge/config/database.yml':
    ensure  => present,
    content => template('forge/database.yml.erb'),
    owner   => $user,
    group   => $group,
    require => Vcsrepo['/opt/forge'],
    before  => Class['forge::raketasks'],
  }

  file { '/opt/forge/config/secrets.yml':
    owner   => $user,
    group   => $group,
    ensure  => present,
    content => template('forge/secrets.yml.erb'),
    require => Vcsrepo['/opt/forge'],
    before  => Class['forge::raketasks'],
  }


  if $newrelic == true {
      file { '/opt/forge/config/newrelic.yml':
        owner => $user,
        group => $group,
        ensure  => present,
        source  => 'puppet:///modules/forge/newrelic.yml',
        require => [ Vcsrepo['/opt/forge'], Package['newrelic_rpm'] ],
      }

      package{ 'newrelic_rpm':
        ensure   => present,
        provider => gem,
        require  => Vcsrepo['/opt/forge'],
      }
  }

  file { [ '/opt/forge/tmp', '/opt/forge/log' ]:
    owner => $user,
    group => $group,
    ensure => directory,
    require => Vcsrepo['/opt/forge'],
  }


  case $appserver {
    'passenger': {
      # untested since migration to unicorn. Left in for optimistic
      # legacy!
      include forge::passenger
    }
    'unicorn': {
      # do magic.

      # Install unicorn only after we've installed rack to the correct
      # version. This is a sea of dependancy horror.
      class{ 'forge::unicorn':
        vhost         => $vhost,
        serveraliases => $serveraliases,
        ssl           => $ssl,
      }
      include forge::packages
      Vcsrepo['/opt/forge'] -> Class['forge::packages'] -> Package['unicorn']
    }
  }

  include forge::raketasks
}

class forge::raketasks {

  # Consult the readme in the forge project.
  # https://github.com/puppetlabs/puppet-forge/blob/master/README.md
  #
  # Steps to build/create the database in the first place.
  exec { 'rakeforgemigrate':
    command     => 'rake db:migrate RAILS_ENV=production',
    cwd         => '/opt/forge',
    user        => $user,
    group       => $group,
    path        => '/bin:/var/lib/gems/1.8/bin:/usr/bin:/usr/sbin',
    require     => [ Vcsrepo['/opt/forge'], Class['forge::packages'], Exec['rakeforgedb'] ],
    subscribe   => Vcsrepo['/opt/forge'],
    logoutput   => true,
    refreshonly => true,
  }

  exec { 'rakeforgeclear':
    command     => 'rake clear RAILS_ENV=production',
    cwd         => '/opt/forge',
    user        => $user,
    group       => $group,
    path        => '/bin:/var/lib/gems/1.8/bin:/usr/bin:/usr/sbin',
    refreshonly => true,
    require     => [ Vcsrepo['/opt/forge'], Class['forge::packages'], Exec['rakeforgemigrate'] ],
    subscribe   => Vcsrepo['/opt/forge'],
    notify      => $forge::appserver ? {
      'unicorn'   => Service['unicorn_forge'],
      'passenger' => Exec['rakeforgerestart'],
    },
    logoutput   => true,
  }

  # I am needed for passenger.
  exec { 'rakeforgerestart':
    command     => 'touch /opt/forge/tmp/restart.txt',
    cwd         => '/opt/forge',
    user        => $user,
    group       => $group,
    path        => '/usr/bin:/usr/sbin:/bin',
    refreshonly => true,
  }

  # So, it seems on creation we need to migrate _twice_ before it
  # actually works. I think.
  exec { 'rakeforgedb':
    command    => 'rake db:create RAILS_ENV=production && rake db:migrate RAILS_ENV=production',
    cwd        => '/opt/forge',
    user       => $user,
    group      => $group,
    path        => '/bin:/var/lib/gems/1.8/bin:/usr/bin:/usr/sbin',
    creates    => '/opt/forge/db/production.sqlite3',
    before     => Exec['rakeforgemigrate'],
    require    => [ Vcsrepo['/opt/forge'], Class['forge::packages']],
    logoutput  => true,
  }

}

class forge::packages {

  # So gems needs some packages around it. This can be split to a
  # params class later. My fear here is them clashing with them being
  # required in other classes. Virtuals would help here.
  # Install them before Vcsrepo runs, as the subsequent gems depend on
  # that. Further down the rabbit hole...
  if $operatingsystem == 'debian' {
    package{ [ 'make', 'libsqlite3-dev', 'gcc', 'g++' ]:
      ensure => present,
    }
  }

  package { 'bundler':
    ensure   => present,
    provider => gem,
  }

  exec { "bundle install" :
    cwd     => '/opt/forge',
    path    => '/bin:/usr/bin:/var/lib/gems/1.8/bin',
    require => Package['bundler'],
    logoutput => true,
  }
}
