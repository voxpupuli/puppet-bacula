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
  $version = 'HEAD'
) {

  # Requirements
  include vcsrepo

  $user = 'deckard'
  $path = '/opt/robopuller'

  user{ $githubrobotpuller::user:
    ensure => present,
    system => true
  }

  # We don't have a file{ .. } here as vcsrepo complains.
  vcsrepo{ $githubrobotpuller::path:
    source   => 'git://github.com/puppetlabs/Ruby-GitHub-Pull-Request-Email-Bot.git',
    provider => 'git',
    owner    => $githubrobotpuller::user, # only in recent vcsrepo.
    revision => $githubrobotpuller::version,
    ensure   => latest,
    require  => User[ $githubrobotpuller::user ],
  }

  file{ "$githubrobotpuller::path/config.yaml":
    ensure  => present,
    source  => 'puppet:///modules/githubrobotpuller/config.yaml',
    owner   => $githubrobotpuller::user,
    mode    => '0644',
    require => Vcsrepo[ $githubrobotpuller::path ],
  }

  package{ [ 'mustache', 'pony', 'octocat_herder']:
    ensure   => present,
    provider => 'gem',
    before   => Vcsrepo[ $githubrobotpuller::path ],
  }

  cron{ "runrobotrun":
    command => "( cd $githubrobotpuller::path && env PATH=\$PATH:/usr/sbin RUBYLIB=\$(pwd)/lib bin/pull-request-bot )",
    minute  => '*/15',
    user    => $githubrobotpuller::user,
    require => File[ "$githubrobotpuller::path/config.yaml" ],
  }

}
