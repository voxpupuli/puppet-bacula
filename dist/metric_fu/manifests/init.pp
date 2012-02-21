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
#   rubygems (for the gem provider) correctly installing binaries into path. Check this on Debian.
#   Metric_fu can consume up 2-300MB of memory while running; 500MB at least is recommended.
#
# Sample Usage:
#   include metric_fu [or] class { "metric_fu" : site_alias => "metricsvhost.puppetlabs.lan" }
#   metric_fu::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/master", repo_name => "puppet"}

class metric_fu ( $site_alias = $fqdn )
 {
  include apache
  
  $parent_dir   = "/opt/metrics"
  $web_root     = "$parent_dir/www"
  $owner        = "www-data"
  $group        = "www-data"
  $metricfu_cmd = "/usr/bin/metrical"
  $port         = 80
  
  apache::vhost{"$site_alias":
    docroot  => $web_root,
    port     => $port,
    ssl      => false,
  }
  
  package { ["git-core"]:
    ensure => present,
  }
  package { ["bison"]:
    ensure => present,
  }
  package { ["metrical","rspec","mocha","zaml","ripper","haml","stomp"]:
    ensure => present,
    provider => gem,
    require => [Package["bison"]],
  }

  file { $parent_dir:
     group  => $group,
     owner  => $owner,  
     mode   => 644,  
     ensure => directory,
  }

  file { $web_root:
     group    => $group,
     owner    => $owner,  
     mode     => 644,  
     ensure   => directory,
     require  => File[$parent_dir],
  }
}
