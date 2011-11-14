node syn {
  include role::server

  class { "graphite" : site_alias => "graphite.puppetlabs.lan" }

  class { "metric_fu" : site_alias => "metrics.puppetlabs.lan" }

  metric_fu::codebase { "puppet" : repo_url => "https://github.com/puppetlabs/puppet.git", repo_rev => "origin/master", repo_name => "puppet"}
  metric_fu::codebase { "facter" : repo_url => "https://github.com/puppetlabs/facter.git", repo_rev => "origin/master", repo_name => "facter"}

  ssh::allowgroup  { "interns": }
  sudo::allowgroup { "interns": }

  package { ["rest-client","mime-types"]: provider => gem, ensure => present, }
  package { "ii": ensure => present, }

  cron {
    "start_ii.sh":
      command => "/opt/start_ii.sh",
      user    => root,
      minute  => "*/3";
    "gather.rb":
      command => "cd /opt/gather && bin/gather --server localhost --port 2003",
      user    => root,
      minute  => "*";
  }

  $bacula_director = 'bacula01.puppetlabs.lan'
  $bacula_password = 'zu4GxF8ij0JI6zgo0OaPcxnqVZRqIO8AvdNb48ssfGG47wtystSKkBFIzoGvtS8'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

}

