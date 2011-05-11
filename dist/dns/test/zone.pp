dns::zone {
    "zlan": # will be $ORIGIN
        zonetype => "master",
        soa => "operator.zlan", # this will also be NS
        reverse => 'false'; # default?
    "18.210.10.in-addr.arpa": # 18.210.10.in-addr.arpa
        zonetype => "master",
        soa => "operator.zlan", # this will also be NS
        reverse => 'true';
}

dns::host {
    "host1":
        ip => '10.210.18.5',
        zone => 'zlan',
        rectype => 'A', #default A
}

dns::zonefile {
    "$name":
        contact => 'root@zlan.',
        soa => 'carbon.zlan.',
        serial => "123";
}
