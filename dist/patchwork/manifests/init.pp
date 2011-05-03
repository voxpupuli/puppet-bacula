class patchwork {
  $patchwork_db_name="patchwork"
  $patchwork_db_user="patchwork"
  $patchwork_db_pass="Xeexoh5E"

  package { 
    "postgresql":                  ensure => installed; 
    "python-psycopg2":            ensure => installed; 
    "python-django-registration": ensure => installed; 
    "libapache2-mod-wsgi": ensure => installed; 
    "postfix": ensure => installed; 
  }

  file { 
    "/srv/patchwork/apps/local_settings.py":
      owner => root,
      group => root,
      mode  => 644,
      content => template("patchwork/local_settings.py.erb");
    "/var/lib/bacula": ensure => directory;
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

  Account::User <| tag == 'patchwork' |>
  Group <| tag == 'patchwork' |>

}
