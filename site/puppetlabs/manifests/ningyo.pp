class puppetlabs::ningyo {

  ###
  # Mysql
  #
  $mysql_root_pw = 'Vrs4ZnacNhr41v'
  include mysql::server

  ###
  # Puppet
  #
  $dashboard_site = 'dashboard.puppetlabs.com'

  $modulepath = [
    '$confdir/environments/$environment/site',
    '$confdir/environments/$environment/dist',
    '$confdir/global/imported',
  ]

  class { "puppet::server":
    modulepath => inline_template("<%= modulepath.join(':') %>"),
    dbadapter  => "mysql",
    dbuser     => "puppet",
    dbpassword => "M@gickF$ck!ngP@$$w0rddd!",
    dbsocket   => "/var/run/mysqld/mysqld.sock",
    reporturl  => "http://dashboard.puppetlabs.com/reports",
    servertype => "unicorn",
  }

}

