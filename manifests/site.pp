# site setup
node default {
    notice("$hostname is not part of any node definition")
}

node base {
    include puppet
    include bc
    include yum
}

node webapp inherits base {
    include bc::app
}   

node manager inherits base {
    include bc::app::manager
    include cron::manager
}

node 'nantahala.vw.bcinfra.net' {
    include puppet::server
    include bc
    include yum
}

node rootdb {
    include puppet
    include cron::rootdb-alluser
}

node 'puppet-test' inherits webapp {}
node 'harvard.vw.bcinfra.net' inherits webapp {}
node 'lincoln.vw.bcinfra.net' inherits webapp {}
#node 'massive.vw.bcinfra.net' inherits webapp {}
node 'grays.vw.bcinfra.net' inherits webapp {}
node 'torreys.vw.bcinfra.net' inherits webapp {}
node 'castle.vw.bcinfra.net' inherits webapp {}
node 'longs.vw.bcinfra.net' inherits webapp {}
node 'wilson.vw.bcinfra.net' inherits webapp {}
node 'cameron.vw.bcinfra.net' inherits webapp {}
node 'carson.vw.bcinfra.net' inherits webapp {}
node 'evans.vw.bcinfra.net' inherits webapp {}
node 'maroon.vw.bcinfra.net' inherits webapp {}
node 'arcadia.vw.bcinfra.net' inherits webapp {}
node 'arches.vw.bcinfra.net' inherits webapp {}
node 'badlands.vw.bcinfra.net' inherits webapp {}
node 'bigbend.vw.bcinfra.net' inherits webapp {}
node 'bryce.vw.bcinfra.net' inherits webapp {}

node 'crater.vw.bcinfra.net' inherits manager {}
node 'carlsbad.vw.bcinfra.net' inherits manager {}

node 'aramis.vw.bcinfra.net' inherits rootdb {}
node 'athos.vw.bcinfra.net' inherits rootdb {}
node 'porthos.vw.bcinfra.net' inherits rootdb {}
