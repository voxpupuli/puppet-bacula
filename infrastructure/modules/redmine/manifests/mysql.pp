# this module requires access to the gitrepo
# or url can be set to some inernal location
# redmine server
#
#
# this holds all of the mysql specific congig
#
#
class redmine::mysql {
  require mysql::server
  database{$redmine_db:
    ensure  => present,
    charset => 'utf8',
  }
  database_user{"${redmine_db_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($redmine_db_password),
  }
  database_grant{"${redmine_db}}@localhost/${redmine_db}":
    privileges => [ 'alter_priv', 'insert_priv', 'select_priv', 'update_priv' ],
#    privileges => all,
  }
}
