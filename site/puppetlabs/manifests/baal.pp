# Class: puppetlabs::baal
#
# This class installs and configures Baal
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::baal {

  ###
  # Mysql
  #
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'
  include mysql::server

  ###
  # Base
  #
  include puppetlabs_ssl
  include account::master
  include vim

  ssh::allowgroup { "release": }

  # Puppet modules
  $dashboard_site = 'dashboard.puppetlabs.com'

  $modulepath = [
    "/etc/puppet/modules/site",
    "/etc/puppet/modules/dist",
  ]

  class { "puppet::server":
    modulepath => inline_template("<%= modulepath.join(':') %>"),
    dbadapter  => "mysql",
    dbuser     => "puppet",
    dbpassword => "password",
    dbsocket   => "/var/run/mysqld/mysqld.sock",
    reporturl  => "http://dashboard.puppetlabs.com/reports";
  }

  class { "puppet::dashboard":
    db_user => "dashboard",
    db_pw   => "Og7iSwrA2sjx",
    site    => "dashboard.puppetlabs.com";
  }

  ###
  # Package repositories
  #
  class { "apt::server::repo": site_name => "apt.puppetlabs.com"; }
  include yumrepo


  ###
  # Bacula
  #
  $bacula_password = 'pc08mK4Gi4ZqqE9JGa5eiOzFTDPsYseUG'
  $bacula_director = 'baal.puppetlabs.com'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'qhF4M6TADEkl',
  }

  bacula::director::pool {
    "PuppetLabsPool-Full":
      volret      => "3 months",
      maxvolbytes => '2000000000',
      maxvoljobs  => '2',
      label       => "Full-";
    "PuppetLabsPool-Inc":
      volret      => "21 days",
      maxvolbytes => '4000000000',
      maxvoljobs  => '50',
      label       => "Inc-";
  }

  # commented in favor of above paramaterized classes
  #zleslie: include bacula
  #zleslie: include bacula::director

  ###
  # Monitoring
  #
  class { "nagios::server": site_alias => "nagios.puppetlabs.com"; }
  include nagios::webservices
  include nagios::dbservices
  # zleslie: include nagios::bacula
  nagios::website { 'apt.puppetlabs.com': }
  nagios::website { 'yum.puppetlabs.com': }
  nagios::website { 'nagios.puppetlabs.com': auth => 'monit:5kUg8uha', }
  nagios::website { 'dashboard.puppetlabs.com': auth => 'monit:5kUg8uha', }
  nagios::website { 'munin.puppetlabs.com': auth => 'monit:5kUg8uha', }
  nagios::website { 'visage.puppetlabs.com': auth => 'monit:5kUg8uha', }

  # Munin
  class { "munin::server": site_alias => "munin.puppetlabs.com"; }
  include munin::dbservices
  include munin::passenger
  include munin::puppet
  include munin::puppetmaster


  #file { "/usr/share/puppet-dashboard/public/.htaccess":
  #  owner => root,
  #  group => www-data,
  #  mode => 0640,
  #  source => "puppet:///modules/puppetlabs/webauth";
  #}

  # pDNS
  include pdns

  # Gitolite
  Account::User <| tag == 'git' |>

  apache::vhost { 'baal.puppetlabs.com': # vhost supporting plapt repo
    options  => "None",
    priority => '08',
    port     => '80',
    docroot  => '/var/www',
  }

  file {
    "/usr/local/bin/puppet_deploy.sh":
      owner => root,
      group => root,
      mode  => 0750,
      source => "puppet:///modules/puppetlabs/puppet_deploy.sh";
  }

  cron {
    "compress_reports":
      user => root,
      command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml" -mtime +1 -exec gzip {} \;',
      minute => '9';
    "clean_old_reports":
      user => root,
      command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml.gz" -mtime +30 -exec rm {} \;',
      minute => '0',
      hour => '2';
    "clean_dashboard_reports":
      user => root,
      command => '(cd /usr/share/puppet-dashboard/; rake RAILS_ENV=production reports:prune upto=1 unit=wk)',
      minute => '20',
      hour => '2';
    "Puppet: puppet_deploy.sh":
      user    => root,
      command => '/usr/local/bin/puppet_deploy.sh',
      minute  => '*/8',
      require => File["/usr/local/bin/puppet_deploy.sh"];
  }

}

