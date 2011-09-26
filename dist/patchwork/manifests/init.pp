class patchwork {
  include postfix

  $patchwork_db_name="patchwork"
  $patchwork_db_user="patchwork"
  $patchwork_db_pass="Xeexoh5E"

  package {
    "postgresql":                 ensure => installed;
    "python-psycopg2":            ensure => installed;
    "python-django-registration": ensure => installed;
    "libapache2-mod-wsgi":        ensure => installed;
  }

  file {
    "/srv/patchwork/apps/local_settings.py":
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("patchwork/local_settings.py.erb");
    "/var/lib/bacula/pgsql": ensure => directory;
    "/home/patchwork/.pwclientrc":
        owner  => patchwork,
        group  => patchwork,
        mode   => 644,
        source => "puppet:///modules/patchwork/_pwclientrc";
    "/home/patchwork/bin/pwparser":
        ensure => symlink,
        target => "/srv/patchwork/apps/patchwork/parser.py";
  }

  apache::vhost {'app01.puppetlabs.lan':
    port     => 443,
    docroot  => '/srv/patchwork',
    ssl      => false,
    priority => 10,
    template => 'patchwork/patchwork.conf.erb',
  }

  apache::vhost::redirect {
    'patchwork.puppetlabs.com':
      port => '80',
      dest => 'https://patchwork.puppetlabs.com'
  }

  cron {
    "patchwork_sql_dump":
      user    => root,
      command => "sudo -i -u patchwork pg_dump | gzip > /var/lib/bacula/pgsql/bacula.sql.gz",
      minute  => 1,
      hour    => 1;
    "fetchmail":
      user => patchwork,
      command => '/usr/bin/fetchmail -s --mda "/srv/patchwork/apps/patchwork/bin/parsemail.sh"',
      minute => '*/10';
    "repoupdate":
      user => patchwork,
      command => '/usr/bin/setlock -nx ~/.repoupdate /home/patchwork/bin/update-repos-and-patchwork ~/repos',
      minute => '*/15';
  }

  exec {
    "clone puppet":
      command => '/usr/bin/git clone --bare git://github.com/puppetlabs/puppet.git',
      cwd     => '/home/patchwork/repos',
      creates => '/home/patchwork/repos/puppet.git',
      user    => 'patchwork';
    "clone dashboard":
      command => '/usr/bin/git clone --bare git://github.com/puppetlabs/puppet-dashboard.git',
      cwd     => '/home/patchwork/repos',
      creates => '/home/patchwork/repos/puppet-dashboard.git',
      user    => 'patchwork';
    "clone facter":
      command => '/usr/bin/git clone --bare git://github.com/puppetlabs/facter.git',
      cwd     => '/home/patchwork/repos',
      creates => '/home/patchwork/repos/facter.git',
      user    => 'patchwork';
  }

  file {
    "/home/patchwork/repos/facter.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/facter.config";
    "/home/patchwork/repos/puppet.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/puppet.config";
    "/home/patchwork/repos/puppet-dashboard.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/puppet-dashboard.config";
    "/home/patchwork/repos/puppetlabs-stdlib.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/puppetlabs-stdlib.config";
    "/home/patchwork/repos/puppetlabs-cloud-provisioner.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/puppetlabs-cloud-provisioner.config";
    "/home/patchwork/repos/marionette-collective.git/config":
      owner => patchwork,
      source => "puppet:///modules/patchwork/marionette-collective.config";
  }

  Account::User <| tag == 'patchwork' |>
  Group <| tag == 'patchwork' |>

  bacula::job {
    "${fqdn}-patchwork":
      files => ["/srv","/var/lib/bacula/pgsql","/home/patchwork"],
  }

}
