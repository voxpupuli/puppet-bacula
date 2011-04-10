#INPUT
firewall { '0010-INPUT allow Loopback':
  iniface => 'lo',
  chain   => 'INPUT',
  jump    => 'ACCEPT'
}

firewall { '0005-INPUT Disregard DHCP':
    dport   => ['bootpc','bootps'],
    jump    => 'DROP',
    proto   => 'udp'
}

firewall { '0006-INPUT Disregard netbios port 137-139':
    proto   => 'udp',
    dport   => ['netbios-ns','netbios-dgm','netbios-ssn'],
    jump    => 'DROP',
}

firewall { '0006 Disregard CIFS port 445':
    dport   => 'microsoft-ds',
    jump    => 'DROP',
    proto   => 'tcp',
}

firewall { '0050-INPUT drop INVALID':
    state   => 'INVALID',
    jump    => 'DROP',
}

firewall { '0051-INPUT allow RELATED,ESTABLISHED':
    state   => [ 'RELATED', 'ESTABLISHED' ],
    jump    => 'ACCEPT',
}

firewall { '0053-INPUT allow ICMP':
    icmp    => '8',
    proto   => 'icmp',
    jump    => 'ACCEPT',
}

firewall { '0055-INPUT allow DNS responses':
    proto   => 'udp',
    jump    => 'ACCEPT',
    sport => 'domain',
}

# FORWARD
firewall { '9999-FORWARD drop default':
    chain => 'FORWARD',
    jump  => 'DROP',
}

# OUTPUT
firewall { '0001-OUTPUT allow Loopback':
    chain    => 'OUTPUT',
    outiface => 'lo',
    jump     => 'ACCEPT',
}

firewall { '0100-OUTPUT drop INVALID':
    chain   => 'OUTPUT',
    state   => 'INVALID',
    jump    => 'DROP',
}
