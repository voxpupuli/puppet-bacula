# As per ticket https://projects.puppetlabs.com/issues/7849
#
# A class to put Jacob's github pull request emailer bot in to action.
#
# Should just need to include it. Once.
#
# Also see
# https://github.com/jhelwig/Ruby-GitHub-Pull-Request-Email-Bot
#

class githubrobotpuller (
  $version = undef
) {

  # Requirements
  include vcsrepo

  $user = 'deckard'
  $path = '/opt/robopuller'

  if $version == undef {
    $revision = 'HEAD'
  } else {
    $revision = $version
  }

  user{ $githubrobotpuller::user:
    ensure => present,
    system => true
  }

  file{ $githubrobotpuller::path:
    ensure  => directory,
    owner   => $githubrobotpuller::user,
    require => User[ $githubrobotpuller::user ],
  }

  vcsrepo{ $githubrobotpuller::path:
    source   => 'git://github.com/jhelwig/Ruby-GitHub-Pull-Request-Email-Bot.git',
    provider => 'git',
    revision => $githubrobotpuller::revision,
    ensure   => present,
    require  => File[ $githubrobotpuller::path ],
  }

  file{ "$githubrobotpuller::path/config.yaml":
    ensure  => present,
    source  => 'puppet:///modules/githubrobotpuller/config.yaml',
    owner   => $githubrobotpuller::user,
    mode    => '0644',
    require => Vcsrepo[ $githubrobotpuller::path ],
  }

  package{ [ 'httparty', 'mustache', 'pony']:
    ensure   => present,
    provider => 'gem',
    before   => Vcsrepo[ $githubrobotpuller::path ],
  }

  #cron{ "runrobotrun":
  #  command => "( cd githubrobotpuller::path && env PATH=$PATH:/usr/sbin RUBYLIB=\$(pwd)/lib bin/pull-request-bot )",
  #  minutes => '*/15',
  #  require => File[ "$githubrobotpuller::path/config.yaml" ],
  #}


}
