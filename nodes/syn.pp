node syn {
  include role::server

  class { "graphite" : site_alias => "graphite.puppetlabs.lan" }

  class { "metric_fu" : site_alias => "metrics.puppetlabs.lan" }

  metric_fu::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/master"}
  metric_fu::codebase { "facter" : repo_url => "https://github.com/puppetlabs/facter.git", repo_rev => "origin/master"}

  ssh::allowgroup  { "interns": }
  sudo::allowgroup { "interns": }

  package { ["rest-client","mime-types"]: provider => gem, ensure => present, }
  package { "ii": ensure => present, }

  file { "/var/lib/gather":
    ensure => directory,
    owner  => root,
    mode   => 750,
  }

  cron {
    "start_ii.sh":
      command => "/opt/start_ii.sh",
      user    => root,
      minute  => "*/3";
    "gather.rb":
      command => "(cd /opt/gather && ./bin/gather --server localhost --port 2003)",
      user    => root,
      minute  => "*";
  }

  class { "gdash" : site_alias => "stats.puppetlabs.lan" }

  file {
    "/opt/gdash/graph_templates/dashboards":
      owner   => root,
      group   => www-data,
      mode    => 0644,
      ensure  => directory,
      recurse => true,
      source  => "puppet:///modules/puppetlabs/graphs";
  }

  logrotate::job {
    "gather info.log":
      log        => "/opt/gather/log/info.log",
      options    => ["rotate 28", "daily", "compress", "notifempty","sharedscripts"],
  }

  bacula::job {
    "${fqdn}-gather":
      files => ["/opt/gather"],
  }

}

