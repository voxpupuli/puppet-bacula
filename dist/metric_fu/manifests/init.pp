# Class: metric_fu
#
# Parameters: none
#
# Actions:
#   Installs metric_fu and its prereqs and configures an apache vhost to serve its output.
#
# Requires:
#   Module "apache" and its dependencies (specifically, a2enmod must be present)
#   Module "vcsrepo" (some vcsrepo provider must be present; if it is not git, git will be installed)
#   rubygems (for the gem provider)
#   Metric_fu can consume up to 800MB of memory while running; 1GB at least is recommended.
#
# Sample Usage:
#   metric_fu::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/next", repo_name => "puppet"}

class metric_fu {
  include apache
  include vcsrepo
  
  $parent_dir = "/opt/metric_fu"
  $web_root = "$parent_dir/www"
  $owner = "www-data"
  $group = "www-data"
  $metricfu_cmd = "/usr/bin/rake metrics:all"
  $port = 80
  
  apache::vhost{"metrics":
    docroot  => $web_root,
    port => $port,
  }
  
  package { ["git-core"]:
    ensure => present,
  }
  package { ["rake"]:
    ensure => present,
  }
  package { ["metric_fu","rspec"]:
    ensure => present,
    provider => gem,
    require => [Package["main"],Package["ruby_parser"]],
  }
  package { ["main"]:
    ensure => "4.7.1", # chronic dependency breaks starting in 4.7.2
    provider => gem,
  }
  package { ["ruby_parser"]:
    ensure => "2.0.4",
    provider => gem,
  }

  file { $parent_dir:
     group => $group,
     owner => $owner,  
     mode => 644,  
     ensure => directory,
#     recurse => true,
  }

  file { $web_root:
     group => $group,
     owner => $owner,  
     mode => 644,  
     ensure => directory,
     require => File[$parent_dir],
#     recurse => true,
  }
}
