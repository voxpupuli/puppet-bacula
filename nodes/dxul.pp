node dxul {

  include role::server

  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs_ssl
  include account::master

  # Puppet
  #$dashboard_site = 'demo.puppetlabs.com'
  #$puppet_storedconfig_password = 'password'

  # Nagios
  include nagios::webservices
  nagios::website { 'projects.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::puppet

  include mysql::server
  redmine::unicorn { 'projects.puppetlabs.com':
    version => '2435525db2c08c68e18cfde56b03bf654e6d92e9',
    dir     => '/opt',
    db      => 'projectspuppetlabscom',
    db_user => 'redmine',
    db_pw   => 'c@11-m3-m1st3r-p1t4ul',
    port    => '80',
    webserver => 'none', # deal with webserving later on.
  }

  # Throw nginx in the mix.
  include nginx::server
  file { '/var/run/unicorn/': ensure => directory, owner => 'root', group => 'www-data', mode => 0550 } ->
  nginx::unicorn {
    'projects.puppetlabs.com':
      ssl            => true,
      unicorn_socket => '/var/run/unicorn/redmine.sock',
      path           => '/opt/projects.puppetlabs.com/public/',
      template       => 'nginx/vhost-redmine-unicorn.nginx.erb',
      isdefaultvhost => true,
      require        => Redmine::Unicorn['projects.puppetlabs.com'],
      before         => Class['nagios::webservices'],
  }

  nginx::vhost::redirect {
    'projects.reductivelabs.com':
        priority   => 20,
        ssl        => true,
        dest       => 'https://projects.puppetlabs.com';
    'forge.puppetlabs.com':
        priority   => 30,
        ssl        => true,
        dest       => 'https://newforge.puppetlabs.com';
  }

  bacula::job {
    "${fqdn}-redmine":
      files    => ["/var/lib/bacula/mysql","/opt/projects.puppetlabs.com"],
  }


  # pDNS
  class { "pdns": ensure => absent; }

  file{ '/usr/local/sbin/cron_imap_runner.sh':
    source => 'puppet:///modules/redmine/cron_imap_runner.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    before => Cron['redmine_tickets_email'],
  }

  cron {
    "redmine_tickets_email":
      user    => www-data,
      minute  => "*/10",
      command => '/usr/local/sbin/cron_imap_runner.sh all';

    "redmine_infras_email":
      user    => www-data,
      minute  => "*/10",
      ensure  => absent,
      command => 'rake --silent -f /opt/projects.puppetlabs.com/Rakefile redmine:email:receive_imap RAILS_ENV="production" host=imap.gmail.com username=tickets@puppetlabs.com password="5JjteNVs" port=993 ssl=true move_on_success=read move_on_failure=failed project=puppetlabs-infras allow_override=project folder=infras';

    # A slew of git "backup" cron jobs, which just throw stuff in
    # /opt/git so bacula backs them up. These are the ones taken from
    # crontab that actually worked at time of writing.
    'git_backups':
      minute => 0,
      hour => '*/3',
      command => 'for i in puppet puppet-docs puppet-dashboard facter; do ( cd "/opt/git/${i}" && git --bare fetch --quiet --force origin master:master > /dev/null ) ; done';
    'git_backups_puppet_24':
      minute => 0,
      hour => '*/3',
      command => 'cd /opt/git/puppet && git --bare fetch --quiet --force origin 0.24.x:0.24.x > /dev/null';
    'git_backups_puppet_25':
      minute => 0,
      hour => '*/3',
      command => 'cd /opt/git/puppet && git --bare fetch --quiet --force origin 0.25.x:0.25.x > /dev/null';
    'git_backups_puppet_26':
      minute => 0,
      hour => '*/3',
      command => 'cd /opt/git/puppet && git --bare fetch --quiet --force origin 2.6.x:2.6.x > /dev/null';
  }

}
