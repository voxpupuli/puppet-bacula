class puppetlabs::mon0 {

  include ganglia::server

  include graphite

  # gather project
  package { "libxml-simple-perl": ensure => installed; }

#  apache::vhost {'mon0.puppetlabs.lan':
#    port => 80,
#    docroot => '/var/www',
#    ssl => false,
#    priority => 10,
#    template => 'ganglia/apache.conf.erb',
#  }

  file {
    "/usr/local/bin/redmine_gmetric.pl":
      source => "puppet:///modules/puppetlabs/redmine_gmetric.pl",
      owner => root,
      group => root,
      mode => 755;
  }

  file {
    "/opt/graphite/conf/dashboard.conf":
      owner => root,
      group => root,
      mode => 644,
      source => "puppet:///modules/puppetlabs/graphite_dashboard.conf";
  }

  cron { # need to source some files here and run under not zach user
    "redmine_gmetrics.pl": 
      ensure => absent,
      command => "/usr/local/bin/redmine_gmetric.pl",
      user => zach,
      minute => "*/5";
    "start_ii.sh":
      command => "~/bin/start_ii.sh",
      user => zach,
      minute => "*/3";
    "ircusers_graph":
      ensure => absent,
      command => '/usr/bin/gmetric -c /etc/ganglia/gmond.conf --name="ircusers" --value=`~/bin/get_irc_users.sh` --type=int16',
      user => zach,
      minute => "*/5";
    "puppet-users-count":
      ensure => absent,
      command => '/usr/bin/gmetric -c /etc/ganglia/gmond.conf --name="puppet-users_count" --value=`wget -q -O - http://groups.google.com/group/puppet-users | grep Members | awk \'{ print $NF }\'` --type=int16',
      user => zach,
      minute => "*/10";
    "puppet-dev-count":
      ensure => absent,
      command => '/usr/bin/gmetric -c /etc/ganglia/gmond.conf --name="puppet-dev-count" --value=`wget -q -O - http://groups.google.com/group/puppet-dev | grep Members | awk \'{ print $NF }\'` --type=int16',
      user => zach,
      minute => "*/10";
    "gd_irc.sh":
      ensure => absent,
      command => '~/bin/gd_irc_csv.sh >> ~/projects/irc/irc_users.csv',
      user => zach,
      minute => "*/10";
    "gather.rb":
      command => "(cd ~/gather; ./gather.rb)",
      user => zach,
      minute => "*";
  }

  ####
  # Bacula
  #
  $bacula_director = 'bacula01.puppetlabs.lan'
  $bacula_password = '6o2lw26JbwPvJxteWw3gc440p06SnUPOkmwis47bCMZzhvMOraNSVT0JelLK2tX'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
    monitor  => false,
  }

}

