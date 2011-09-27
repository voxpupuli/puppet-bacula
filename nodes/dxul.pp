node dxul {

  include role::server

  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs_ssl
  include account::master

  # Puppet
  #$dashboard_site = 'demo.puppetlabs.com'
  #$puppet_storedconfig_password = 'password'

  # Puppet Forge
  class { 'forge':
    vhost        => 'forge.puppetlabs.com',
    git_revision => '122ddab64eb263417ea973d45a7f39a20cb77d3d',
  }

  # Backup
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '9haB2+SxaNXF2C1LFdptETvihkk/zKro2Hxf+cQFEbIQ'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  # Nagios
  include nagios::webservices
  #nagios::website { 'demo.puppetlabs.com': }
  nagios::website { 'forge.puppetlabs.com': }
  nagios::website { 'projects.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::passenger
  include munin::puppet

  include mysql::server
  redmine::unicorn { 'projects.puppetlabs.com':
    dir     => '/opt',
    db      => 'projectspuppetlabscom',
    db_user => 'redmine',
    db_pw   => 'c@11-m3-m1st3r-p1t4ul',
    port    => '80',
  }

  bacula::job {
    "${fqdn}-redmine":
      files    => ["/var/lib/bacula/mysql","/opt/projects.puppetlabs.com"],
  }

  apache::vhost::redirect {
    'projects.reductivelabs.com':
      port => '80',
      dest => 'http://projects.puppetlabs.com'
  }

  # pDNS
  include pdns

  cron {
    "redmine_infras_email":
      user    => www-data,
      minute  => "*/10",
      command => 'rake --silent -f /opt/projects.puppetlabs.com/Rakefile redmine:email:receive_imap RAILS_ENV="production" host=imap.gmail.com username=tickets@puppetlabs.com password="5JjteNVs" port=993 ssl=true move_on_success=read move_on_failure=failed project=puppetlabs-infras allow_override=project folder=infras';
    "redmine_tickets_email":
      user    => www-data,
      minute  => "*/10",
      command => 'rake --silent -f /opt/projects.puppetlabs.com/Rakefile redmine:email:receive_imap RAILS_ENV="production" host=imap.gmail.com username=tickets@puppetlabs.com password="5JjteNVs" port=993 ssl=true move_on_success=read move_on_failure=failed project=puppet allow_override=project folder=tickets';
  }

}
