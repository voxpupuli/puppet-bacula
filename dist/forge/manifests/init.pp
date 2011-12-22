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
    $git_revision  = 'bee0b91f11197bee486c1c374ddc1257fb966739',
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
  require forge::packages       # see later on, down the page.

  motd::register{ "A Forge at ${vhost}": }

  # If we're deploying from github we may need our deploy keys to do
  # that. Or git/puppet hangs indefinitely.
  if $do_ssh_keys == true or $github_url == 'git@github.com:puppetlabs/puppet-forge.git' {
      include forge::sshkey
  }

  $rails_version='2.3.14'
  require rails
  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path

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
      Class['forge::packages::mustbeinstalledfirst'] -> Class['forge::packages'] -> Package['unicorn']
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
    path        => '/usr/bin:/usr/sbin:/bin',
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
    path        => '/usr/bin:/usr/sbin:/bin',
    refreshonly => true,
    require     => [ Vcsrepo['/opt/forge'], Class['forge::packages']],
    subscribe   => Vcsrepo['/opt/forge'],
    # notify      => Exec['rakeforgerestart'],
    logoutput   => true,
  }

  #   # I am needed for passenger.
  #   exec { 'touch /opt/forge/tmp/restart.txt':
  #     alias       => 'rakeforgerestart',
  #     cwd         => '/opt/forge',
  #     user        => $user,
  #     group       => $group,
  #     path        => '/usr/bin:/usr/sbin:/bin',
  #     require     => [ Vcsrepo['/opt/forge'], Class['forge::packages']],
  #     refreshonly => true,
  #     logoutput   => true,
  #   }

  # So, it seems on creation we need to migrate _twice_ before it
  # actually works. I think.
  exec { 'rakeforgedb':
    command    => 'rake db:create RAILS_ENV=production && rake db:migrate RAILS_ENV=production',
    cwd        => '/opt/forge',
    user       => $user,
    group      => $group,
    path       => '/usr/bin:/usr/sbin:/bin',
    creates    => '/opt/forge/db/production.sqlite3',
    before     => Exec['rakeforgemigrate'],
    require    => [ Vcsrepo['/opt/forge'], Class['forge::packages']],
    logoutput  => true,
  }

}

# Due to idiocy in the gem install ordering, these packages MUST be
# installed first, or other packages pull in newer versions and break
# everything!
class forge::packages::mustbeinstalledfirst {


  # Nastily, this matches up the system rake and the gem installed
  # rake to the same version, otherwise you get super confused and
  # rails breaks with a 'uninitialized constant Rake::DSL' error.
  #
  # Okay, before screaming, at time of writing you can't have two
  # chickens with the same name, even if you alias one. See
  # https://projects.puppetlabs.com/issues/1398 and
  # http://groups.google.com/group/puppet-users/browse_thread/thread/3c9b0193e924c1d8
  # for more details.
  #
  # So I am doing something horrible. Please forgive me.
  # (yeah, it assumes you're using Ruby 1.8 too).
  exec { 'install_rake_gem_and_goto_hell':
    command  => 'gem install rake --version 0.8.7 --no-ri --no-rdoc',
    unless   => 'gem list rake | egrep -q "^rake \(.*0\.8\.7.*\)"',
    path     => '/bin:/usr/bin:/usr/local/bin',
  } ->

  # So, forge needs a rack of 1.1.X and will near silently fail if it
  # doesn't have it (it will bomb out with a rails version issue). Now
  # I don't know a better way of doing this than just throwing it in
  # and hoping it's first.
  package { 'rack':
    ensure => '1.1.2',
    provider => gem,
  }

}

class forge::packages {

  include forge::packages::mustbeinstalledfirst

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

  # Non version specific gems. DANGER WILL ROBINSON.
  package { [ 'json', 'archive-tar-minitar', 'bcrypt-ruby', 'diff-lcs', 'haml', 'maruku', 'versionomy', 'warden', 'sqlite3', 'hpricot', 'vlad', 'vlad-git' ]:
    ensure => present,
    provider => gem,
  }

  package { 'devise':
    ensure => '1.0.7',
    provider => gem,
  }

  package { 'super_exception_notifier':
    ensure => '2.0.0',
    provider => gem,
  }
  package { 'rspec':
    ensure   => '1.3.2',
    provider => gem,
  }

  # otherwise it pulls in newer rails.
  package { 'rspec-rails':
    ensure   => '1.3.4',
    provider => gem,
  }

  # As we have a system package named less, use this horrible method
  # again to get it to work. See install_rake_gem_and_goto_hell for
  # more details.
  exec { 'install_less_gem_and_goto_hell':
    command  => 'gem install less --version 1.2.21 --no-ri --no-rdoc',
    unless   => 'gem list less | egrep -q "^less \(.*1\.2\.21.*\)"',
    path     => '/bin:/usr/bin:/usr/local/bin',
  }

  package{ 'will_paginate':
    ensure => '2.3.16',
    provider => gem,
  }

  packagegemwithnodeps { 'acts-as-taggable-on':
    version => '2.1.1',
  }

  # Which depends on:
  # [root@idun:forge]# gem dependency paperclip -v 2.4.5 | grep runtime
  #  activerecord (>= 2.3.0, runtime)
  #  activesupport (>= 2.3.2, runtime)
  #  cocaine (>= 0.0.2, runtime)
  #  mime-types (>= 0, runtime)
  packagegemwithnodeps{ 'paperclip' :
    version => '2.4.5',
    require => [ Package['cocaine'], Package['mime-types']]
  }

  package{ 'cocaine':
    ensure => '0.2.1',
    provider => gem,
  }

  package{ 'mime-types':
    ensure => '1.17.2',
    provider => gem,
  }


  # Installing remarkable pulls in the later versions of rspec, which
  # pulls in more crap that I don't want. So we do the same thing
  # here.
  #
  # [ben@dxul:~]% for i in $(gem list | awk '/^remarkable/ {print $1}'); do gem dep $i ; done  | grep runtime | sort -u
  # remarkable (~> 3.1.13, runtime)
  # remarkable_activerecord (~> 3.1.13, runtime)
  # rspec (>= 1.2.0, runtime)
  # rspec-rails (>= 1.2.0, runtime)
  packagegemwithnodeps{ [ 'remarkable' , 'remarkable_activerecord' , 'remarkable_rails' ]:
    version => '3.1.3',
    require => [ Package['rspec'], Package['rspec-rails']],
  }


  # Same again, in the code it requires:
  # config.gem 'i18n', :version => '~> 0.3.5'
  package{ 'i18n':
    ensure => '0.3.7',
    provider => gem,
  }

  package{ 'factory_girl':
    ensure   => '2.3.2',
    provider => gem,
    require  => [ Exec['install_rake_gem_and_goto_hell']],
  }

  # Requires:   activerecord (>= 0, runtime)
  packagegemwithnodeps { 'bitmask-attribute':
    version => '1.1.0',
  }

}

# So gems will randomly upgrade a package if it can find a version
# _EVEN_ if it's dependancy has been met. This could be a lack of
# understanding on how gems work, if so, they shouldn't hide their
# fucking documentation so well. But after I asked around, this was
# deemed the least terrible way of doing it.
#
# This is to stop rails 3 being installed by things, even when a rails
# 2.3.x is installed and the gem calls for "rails >0". You then have
# two gems for say, rails, and it activates the wrong one first, and
# bombs out, often silently.
#
# This does mean you're on your own for dependancies... Not ideal
# (almost as if this should be say the package management's job...)
# But it's better than it not working in the first place.
#
# This forge code is "only temporary" so we _shouldn't_ have to
# rebuild it later, so you shouldn't have to ever reuse this. My
# apologises if you do.
#
define packagegemwithnodeps(
  $version = ''
) {

  case $operatingsystem {
    'debian','ubuntu': { }
    # This is because of the creates line in the versioned one, as I
    # still feel doing a gem list on every gem is too expensive!
    default: { fail( "This VILE hack for gems only works on debian/ubuntu. See dist/forge/manifests/init.pp") }
  }

  if $version == '' {
    exec{ "install_gem_badly_for_${name}":
      command => "gem install ${name} --ignore-dependencies --no-ri --no-rdoc",
      path    => '/bin:/usr/bin',
      unless  => "gem list --local ${name} | grep -q '^${name} '" # Not perfect,
                                                       # as doesn't check
                                                       # the version.
    }
  } else {
    exec{ "install_gem_badly_for_${name}":
      command => "gem install ${name} --version ${version} --ignore-dependencies --no-ri --no-rdoc",
      path    => '/bin:/usr/bin',
      creates => "/var/lib/gems/1.8/gems/${name}-${version}",
    }
  }
}
