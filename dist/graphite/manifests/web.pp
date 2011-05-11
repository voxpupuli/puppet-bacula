class graphite::web {

  include graphite::params

#  exec { "download-webapp":
#    command => "wget -O $graphite::params::webapp_dl_loc $graphite::params::webapp_dl_url",
#    creates => "$graphite::params::webapp_dl_loc",
#    require => File["$graphite::params::build_dir"],
#  }

  exec { "unpack-webapp":
    # true is needed to work around a problem with execs and built ins. https://projects.puppetlabs.com/issues/4884 <-- marked closed as of puppet version 2.6.8
    command   => "bash -c 'true && cd $graphite::params::build_dir && tar -zxvf $graphite::params::webapp_dl_loc && cd graphite-web-0.9.8 && patch -p1 < $graphite::params::build_dir/patches/*.diff ;'",
    require   => File["$graphite::params::build_dir/patches"],
    subscribe => Exec["download-webapp"],
    refreshonly => true,
    creates => "$graphite::params::build_dir/graphite-web-0.9.8/",
  }

  exec { "install-webapp":
    # true is needed to work around a problem with execs and built ins. https://projects.puppetlabs.com/issues/4884
    command => "true && cd $graphite::params::build_dir/graphite-web-0.9.8 && python setup.py install",
    subscribe => Exec["unpack-webapp"],
    refreshonly => true,
    creates => "/opt/graphite",
  }

  exec { "initialize-db":
    command => "bash -c 'export PYTHONPATH=/opt/graphite/webapp &&  cd /opt/graphite/webapp/graphite/ && python manage.py syncdb'",
    subscribe => Exec["install-webapp"],
    refreshonly => true,
    user => $graphite::params::web_user,
  }

  file { "/etc/apache2/sites-enabled/graphite.conf":
    source => "puppet:///modules/graphite/graphite-apache-vhost.conf" ,
    subscribe => Exec["install-webapp"],
  }

  file { "/opt/graphite/conf/graphite.wsgi":
    source => "puppet:///modules/graphite/graphite.wsgi",
    subscribe => Exec["install-webapp"],
  }

  file { "/opt/graphite/storage":
    owner => $graphite::params::web_user,
    subscribe => Exec["install-webapp"],
    recurse => inf
  }

  package {
    [python-ldap, python-cairo, python-django, python-simplejson, libapache2-mod-wsgi, python-memcache, python-pysqlite2, python-rrdtool]:
      ensure => latest;
  }
}
