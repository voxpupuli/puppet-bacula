# Class: codemetrics
#
# Parameters: none
#
# Actions:
#   Installs cloc and spec time scripts for graphite
#   and runs them when the repository is updated.
#
# Requires:
#   Module "vcsrepo" (some vcsrepo provider must be present;
#   if it is not git, git will be installed)
#   rubygems (for the gem provider)
#
# Known Issues:
#   The graphite server name / port spec is hard-coded in the Python script.
#   It should really be parametrized here.
#
# Sample Usage:
#   codemetrics::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/next", repo_name => "puppet"}

class codemetrics {
  include vcsrepo

  $parent_dir = "/opt/metrics"  
  $cloc_script = "$parent_dir/cloc.py"
  $spectime_script = "$parent_dir/spectime.py"
  
#  package { ["git-core"]:
#    ensure => present,
#  }
#  package { ["rake"]:
#    ensure => present,
#  }
#  package { ["rspec","mocha"]:
#    ensure => present,
#    provider => gem,
#  }
  package { ["cloc","python2.7"]:
    ensure => present,
  }

#  file { $parent_dir:
#     ensure => directory,
#     recurse => true,
#  }

  file { $cloc_script:
     ensure => present,
     source => "puppet:///modules/codemetrics/cloc.py",
     require => File[$parent_dir],
#     recurse => true,
  }
  
  file { $spectime_script:
     ensure => present,
     source => "puppet:///modules/codemetrics/spectime.py",
     require => File[$parent_dir],
#     recurse => true,
  }
}
