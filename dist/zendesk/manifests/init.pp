class zendesk($root = '/opt/zendesk') {

  require ruby::dev
  require sinatra

  vcsrepo { $root:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jamtur01/zendesk-populator',
    revision => '531ed63d1c9f433b8211b10b73e9645a2f599874',
  }

  file { "${root}/public":
    ensure => directory,
  }

  file { "${root}/config.ru":
    ensure => present,
    source => "puppet:///modules/zendesk/config.ru",
  }

  file { "${root}/config/database.yml":
    ensure  => present,
    content => template('zendesk/database.yml.erb'),
    owner   => $user,
    group   => $group,
    require => Vcsrepo["${root}"],
  }

  file { "${root}/config/config.yml":
    ensure  => present,
    content => template('zendesk/config.yml.erb'),
    owner   => $user,
    group   => $group,
    require => Vcsrepo["${root}"],
  }

  exec { 'rakeforgemigrate':
    command     => 'rake db:migrate RAILS_ENV=production',
    cwd         => $root,
    user        => $user,
    group       => $group,
    path        => '/bin:/var/lib/gems/1.8/bin:/usr/bin:/usr/sbin',
    require     => [ Vcsrepo["${root}"], Class['zendesk::packages']],
    subscribe   => Vcsrepo["${root}"],
    logoutput   => on_failure,
    refreshonly => true,
  }
  include zendesk::packages

}

class zendesk::packages {

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
    cwd       => '/opt/zendesk',
    path      => '/bin:/usr/bin:/var/lib/gems/1.8/bin',
    unless    => 'bundle check',
    require   => Package['bundler'],
    logoutput => on_failure,
  }
}
