#node lvxentest inherits lvxentest{
#
#      exports::nfs { "data1":
#               export => "/export/data1",
#               hosts => "172.24.8.0/255.255.255.0(sync,rw,subtree_check) 172.24.9.0/255.255.255.0(sync,rw,subtree_check) 172.24.16.14/255.255.255.0(sync,rw,subtree_check) lvpremediax01 172.24.16.137",
#       }
#
#       service {"nfs":
#               name => $operatingsystem {
#                       Darwin => "com.apple.nfsd",
#                       Solaris => "network/nfs/server",
#                       default => "nfs",
#               }
#
#               ensure => tagged(production) ? {
#                       true => running,
#                       false => stopped,
#               }
#       }
#}
#
#node lvxentest01 inherits lvxentest {
#   tag(production)
#}
#
#node lvxentest02 inherits lvxentest {
#}

#
# Nodes should be used for assignment avoid putting resources directly inside of nodes. We should use classes and inheritance to model your database servers.
#

class database { 
  file {"/tmp/database_role":
    content => "This is a database server",
  } 
}

class database::production inherits database {
   #
   # Now we can overide the parameters of the file content parameter.  The same could be done for any parameter (i.e. ensure running )
   #
   File["/tmp/database_role":
      content => 'This is a production database server',
   }
   #
   # And of course we can add other resources.
   #
   file {"/tmp/database_state":
      content => 'We like for this server to stay up',
   }
}

class database::backup inherits database::production 
   File["/tmp/database_state"] { content => 'We like for this server to stand-bye' }
}


#
# And the rest is just a matter of assignment in your site.pp file.
#

node lvxentest01 {
   include database::production
}

node lvxentest02 {
   include database::backup
}
