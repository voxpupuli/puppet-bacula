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
class forge {
  include ::passenger
  include passenger::params
  include ruby::dev
  include vcsrepo
  include apache::ssl

  $rails_version='2.3.5'
  require rails
  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path

  file { '/opt/forge':
    owner => 'www-data',
    group => 'sysadmin',
    recurse => true,
    ignore => '.git',
    ensure => directory,
  }

  vcsrepo { '/opt/forge':
    source => 'http://github.com/reductivelabs/puppet-module-site.git',
    provider => git,
    revision => 'r0.1.7',
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
    group => 'sysadmin',
    require => Vcsrepo['/opt/forge'],
  }  

  file { '/opt/forge/config/secrets.yml':
    owner => 'www-data',
    group => 'sysadmin',
    ensure => present,
    content => template('forge/secrets.yml.erb'),
    require => Vcsrepo['/opt/forge'],
  }

  file { '/opt/forge/config/newrelic.yml':
    owner => 'www-data',
    group => 'sysadmin',
    ensure => present,
    source => 'puppet:///modules/forge/newrelic.yml',
    require => Vcsrepo['/opt/forge'],
  }

  file { [ '/opt/forge/tmp', '/opt/forge/log' ]:
    owner => 'www-data',
    group => 'sysadmin',
    ensure => directory,
    require => Vcsrepo['/opt/forge'],
  }

  exec { 'RAILS_ENV=production rake db:migrate':
    alias => 'rakeforgemigrate',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    require => Vcsrepo['/opt/forge'],
    subscribe => Vcsrepo['/opt/forge'],
    refreshonly => true,
  }

  exec { 'RAILS_ENV=production rake clear':
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

  exec { 'RAILS_ENV=production rake db:create':
    alias => 'rakeforgedb',
    cwd => '/opt/forge',
    path => '/usr/bin:/usr/sbin:/bin',
    creates => '/opt/forge/db/production.sqlite3',
    require => Vcsrepo['/opt/forge'],
  }

  apache::vhost { 'forge.puppetlabs.com':
    port => '80',
    priority => '60',
    docroot => '/opt/forge/public/',
    template => 'forge/puppet-forge-passenger.conf.erb',
    require => [ Vcsrepo['/opt/forge'], File['/opt/forge/log'], File['/opt/forge/tmp'], Exec['rakeforgedb'], File['/opt/forge/config/database.yml'], File['/opt/forge/config/secrets.yml'] ],
  }
}
