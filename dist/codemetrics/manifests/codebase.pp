# Definition: codemetrics::codebase
#
# Parameters:
#  $repo_url: the git url of the repository
#  $repo_rev: what branch of that repository to run metrics on
#  $repo_name: what you want to call the directory for the output
#
# Actions:
#  This subclass pulls down one codebase/repo and runs cloc and spec_timing every time it changes.
#  Assumes a git repository, though other vcsrepos should work with minor changes.
#
# Requires:
#   class codemetrics
#
# Sample Usage:
#   codemetrics::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/master", repo_name => "puppet"}

define codemetrics::codebase ($repo_url, $repo_rev, $repo_name) {
  include codemetrics
  
  $timeout   = 0
  $python    = "/usr/bin/python2.7"
  
  $repo_base = "$codemetrics::parent_dir/$repo_name"
  
#  vcsrepo { $repo_base: ## Commented because metric_fu already loads it.
#    ensure   => present,
#    provider => git,
#    revision => $repo_rev,
#    source   => $repo_url,
#    require  => #[File[$codemetrics::parent_dir],Package["git-core"],Package["rake"]],
#  }
  
  exec { "$python $codemetrics::cloc_script $repo_name $repo_base":
    subscribe   => [Vcsrepo[$repo_base],File[$codemetrics::cloc_script]],
    timeout     => $timeout,
    require     => [Package["cloc","python2.7"]],
  }
  
  exec { "$python $codemetrics::spectime_script $repo_name $repo_base":
    subscribe   => [Vcsrepo[$repo_base],File[$codemetrics::spectime_script]],
    timeout     => $timeout,
    require     => [Package["cloc","python2.7"],Package["rspec","mocha"]],
  }
}