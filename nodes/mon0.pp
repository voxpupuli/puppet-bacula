node mon0 {
  include role::server
  include ganglia::server
  include graphite
  include harden

  ssh::allowgroup {"interns": }
  sudo::allowgroup {"interns": }

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

  # Conflicts with dist/graphite/init.pp's file definition.
  # file {
  #   "/opt/graphite/conf/dashboard.conf":
  #     owner => root,
  #     group => root,
  #     mode => 644,
  #     source => "puppet:///modules/puppetlabs/graphite_dashboard.conf";
  # }

  cron { # need to source some files here and run under not zach user
    "start_ii.sh":
      command => "~/bin/start_ii.sh",
      user => zach,
      minute => "*/3";
    "gather.rb":
      command => "(cd ~/gather; ./gather.rb)",
      user => zach,
      minute => "*";
  }

  ####
  # Bacula
  #
  $bacula_director = 'bacula01.puppetlabs.lan'
  class { "bacula":
    director => $bacula_director,
    password => hiera('bacula_password'),
  }

}

