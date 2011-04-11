class puppetlabs::qa {
  # Mysql
  $mysql_root_pw = 'c@11-53-m1st3r-pttya1'
  include mysql::server

  include puppetlabs::lan

  # move this shit into a module
  $packages_list = [
    "python",
    "python-django",
    "python-django-south",
    "python-mysqldb",
    #"python-elementtree",
    "python-markdown",
    "python-html5lib",
    "python-openid",
    "python-sphinx",
    "python-django-debug-toolbar",
    "python-setuptools",
    "sphinxsearch",
    "libapache2-mod-wsgi"
  ]

  package { $packages_list: ensure => installed; }

  apache::vhost {'qa.puppetlabs.lan':
    port => 80,
    docroot => '/home/osqa/osqa-server',
    ssl => false,
    priority => 10,
    template => 'osqa/osqa.conf.erb',
  }

  # values for db and settings_local.py template
  $osqa_db_user = "osqa"
  $osqa_db_pw   = 'jOIULNslaksjdlsknoLKJnkdinsljfhkdfjhKJH'

  mysql::db{"osqa":
    db_user => "$osqa_db_user",
    db_pw => "$osqa_db_pw",
  }

  Account::User <| tag == 'osqa' |>
  Group <| tag == 'osqa' |>

}

