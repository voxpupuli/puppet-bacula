class mrepo {

  include mrepo::settings
  include apache

  vcsrepo { "/usr/src/mrepo":
    ensure    => present,
    provider  => "git",
    source    => "https://github.com/dagwieers/mrepo.git",
  }

  exec { "Install mrepo from source":
    refreshonly => true,
    path        => "/usr/bin:/usr/sbin:/sbin:/bin",
    cwd         => "/usr/src/mrepo",
    refresh     => "make install",
    subscribe   => Vcsrepo["/usr/src/mrepo"],
  }

  # Needed for rhns
  package { "pyOpenSSL":
    ensure  => present,
  }

  file { "/etc/mrepo.conf.d":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => true,
    recurse => true,
  }

  file { 
    "${mrepo::settings::srcroot}":
      ensure  => directory;
    "${mrepo::settings::wwwroot}":
      ensure  => directory;
  }

  file { "/etc/mrepo.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content  => template("mrepo/mrepo.conf.erb"),
  }

  # These are for compatibility with mirroring redhat network repos on CentOS
  # They are not strictly necessary if you're not doing said mirroring, but
  # it doesn't hurt.
  if $operatingsystem == 'CentOS' {
    exec { "Generate rhnuuid":
      command => "/bin/echo -n 'rhnuuid=' > /etc/sysconfig/rhn/up2date-uuid; /usr/bin/uuidgen >> /etc/sysconfig/rhn/up2date-uuid",
      creates  => "/etc/sysconfig/rhn/up2date-uuid",
    }

    file { "/etc/sysconfig/rhn/sources":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => "up2date default",
    }
  }

  cron { "Synchronize mrepo":
    command => "/usr/bin/mrepo -guvvv",
    weekday => "0",
    hour    => "0",
    minute  => "0",
  }

  apache::vhost { "mrepo.conf":
    priority  => "10",
    port      => "80",
    docroot   => "/var/www/mrepo",
    template  => "mrepo/apache.conf.erb",
  }
}
