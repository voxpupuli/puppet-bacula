# Class: forge
#
# This class installs and configures parameters for Puppet Forge
#
# Parameters:
#
# Actions:
#
# Requires:
# - Passenger
# - Ruby::Dev
# - Vcsrepo
# - forge::params
#
# Sample Usage:
#
class forge(
    $vhost         = 'forge.puppetlabs.com',
    $ssl           = true,
    $newrelic      = true,
    $do_ssh_keys   = false
) {
  include ::passenger
  include passenger::params
  include ruby::dev
  include vcsrepo
  include apache::ssl

  if $do_ssh_keys == true {
      include forge::sshkey
  }

  $rails_version='2.3.5'
  require rails
  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path

  file { '/opt/forge':
    owner => 'www-data',
    group => 'www-data',
    #recurse => true,
    ignore => '.git',
    ensure => directory,
  }

  cron {
    "/opt/forge_permissions": # recursion file type makes for huge reports
      command => "/usr/bin/find /opt/forge -print | grep -v \.git | xargs -I {} chown www-data:www-data {}",
      user => root,
      minute => "*/30";
	}

  # so this doesn't work. As it needs a password as it's a private
  # repo.
  vcsrepo { '/opt/forge':
    source => 'http://github.com/puppetlabs/puppet-module-site.git',
    provider => git,
    revision => 'r0.1.16',
    ensure => present,
    require => File['/opt/forge'],
  }
 
  package { [ 'json', 'less', 'archive-tar-minitar', 'bcrypt-ruby', 'diff-lcs', 'haml', 'maruku', 'paperclip', 'versionomy', 'warden', 'will_paginate', 'sqlite3-ruby', 'hpricot', 'factory_girl', 'remarkable_activerecord', 'remarkable_rails', 'rspec', 'rspec-rails', 'vlad', 'vlad-git' ]:
    ensure => present,
    provider => gem,
    require => Vcsrepo['/opt/forge'],
  }
 
  package { 'acts-as-taggable-on':
    ensure => '2.0.4',
    provider => gem,
    require => Vcsrepo['/opt/forge'],
  }

  package { 'bitmask-attribute':
    ensure => '1.1.0',
    provider => gem,
    require => Vcsrepo['/opt/forge'],
  }
 
  package { 'devise':
    ensure => '1.0.7',
    provider => gem,
    require => Vcsrepo['/opt/forge'],
  }

  package { 'super_exception_notifier':
    ensure => '2.0.0',
    provider => gem,
    require => Vcsrepo['/opt/forge'],
  }

  file { '/opt/forge/config/database.yml':
    ensure => present,
    content => template('forge/database.yml.erb'),
    owner => 'www-data',
    group => 'www-data',
    require => Vcsrepo['/opt/forge'],
  }

  file { '/opt/forge/config/secrets.yml':
    owner => 'www-data',
    group => 'www-data',
    ensure => present,
    content => template('forge/secrets.yml.erb'),
    require => Vcsrepo['/opt/forge'],
  }

  if $newrelic == true {
      file { '/opt/forge/config/newrelic.yml':
        owner   => 'www-data',
        group   => 'www-data',
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
    owner => 'www-data',
    group => 'www-data',
    ensure => directory,
    require => Vcsrepo['/opt/forge'],
  }

  file { "/etc/apache2/conf.d/passenger.conf":
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Service["httpd"],
    content => template("forge/passenger.conf.erb");
  }

  exec { 'rake db:migrate RAILS_ENV=production':
    alias => 'rakeforgemigrate',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    require => Vcsrepo['/opt/forge'],
    subscribe => Vcsrepo['/opt/forge'],
    refreshonly => true,
  }

  exec { 'rake clear RAILS_ENV=production':
    alias => 'rakeforgeclear',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    require => Vcsrepo['/opt/forge'],
    subscribe => Vcsrepo['/opt/forge'],
    refreshonly => true,
    notify => Exec['rakeforgerestart'],
  }

  exec { 'touch /opt/forge/tmp/restart.txt':
    alias => 'rakeforgerestart',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    require => Vcsrepo['/opt/forge'],
    refreshonly => true,
  }

  exec { 'rake db:create RAILS_ENV=production':
    alias => 'rakeforgedb',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    creates => '/opt/forge/db/production.sqlite3',
    require => Vcsrepo['/opt/forge'],
  }

  apache::vhost { $vhost:
    port => '80',
    priority => '60',
    ssl => false,
    docroot => '/opt/forge/public/',
    template => 'forge/puppet-forge-passenger.conf.erb',
    require => [ Vcsrepo['/opt/forge'], File['/opt/forge/log'], File['/opt/forge/tmp'], Exec['rakeforgedb'], File['/opt/forge/config/database.yml'], File['/opt/forge/config/secrets.yml'] ],
  }

  if $ssl == true {
      apache::vhost { "${vhost}_ssl":
        port => 443,
        priority => 61,
        docroot => '/opt/forge/public/',
        ssl => true,
        template => 'forge/puppet-forge-passenger.conf.erb',
        require => [ Vcsrepo['/opt/forge'], File['/opt/forge/log'], File['/opt/forge/tmp'], Exec['rakeforgedb'], File['/opt/forge/config/database.yml'], File['/opt/forge/config/secrets.yml'] ],
      }
  }

}
