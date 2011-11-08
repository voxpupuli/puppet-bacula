# Definition: metric_fu::codebase
#
# Parameters:
#  $repo_url: the git url of the repository
#  $repo_rev: what branch of that repository to run metrics on
#  $repo_name: what you want to call the directory for the metric_fu output
#
# Actions:
#  This subclass pulls down one codebase/repo and runs metric_fu every time it changes.
#  Assumes a git repository, though other vcsrepos should work with minor changes.
#
# Requires:
#   class metric_fu to be included first
#
# Sample Usage:
#   include metric_fu [or] class { "metric_fu" : site_alias => "metricsvhost.puppetlabs.lan" }
#   metric_fu::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/master", repo_name => "puppet"}

define metric_fu::codebase ($repo_url, $repo_rev, $repo_name) {
  include metric_fu
  $timeout       = 0
  
  $repo_base     = "$metric_fu::parent_dir/$repo_name"
  $rakefile_path = "$repo_base/tasks/rake/metrics.rake"
  
  vcsrepo { $repo_base:
## you would think this should be latest, but "present" actually always gets the latest rev of desired branch
## latest fires a refresh every time, but this only fires when the source actually changed, which is desirable
    ensure   => present,
    provider => git,
    revision => $repo_rev,
    source   => $repo_url,
    require  => [File[$metric_fu::parent_dir],Package["git-core"],Package["rake"]],
  }
  
  exec { "metric_fu_$repo_name":
    command     => $metric_fu::metricfu_cmd,
#    user       => $metric_fu::owner,
    cwd         => $repo_base,
    subscribe   => Vcsrepo[$repo_base],
    refreshonly => true,
    timeout     => $timeout,
    require     => [Package["main"],Package["metric_fu","rspec","mocha","zaml","rack"],File[$rakefile_path]],
  }

  file { "$metric_fu::web_root/$repo_name":
    group   => $group,
    owner   => $owner,  
    ensure  => link,
    target  => "$repo_base/tmp/metric_fu/output",
    require => [Exec["metric_fu_$repo_name"], File[$metric_fu::web_root]],
  }

  file { "$rakefile_path":
    group   => $group,
    owner   => $owner,  
    ensure  => present,
    source  => "puppet:///modules/metric_fu/metrics.rake",
    require => [Vcsrepo["$repo_base"]],
  }
}
