#INPUT
firewall { '0100-INPUT allow Loopback':
  iniface => '0:0:0:0:0:0:0:1',
  chain   => 'INPUT',
  jump    => 'ACCEPT',
  provider => 'ip6tables'
}

firewall { '0005-INPUT Disregard DHCP':
  dport   => ['bootpc','bootps'],
  jump    => 'DROP',
  proto   => 'udp',
  provider => 'ip6tables'
}

firewall { '0006-INPUT Disregard netbios port 137-139':
  proto   => 'udp',
  dport   => ['netbios-ns','netbios-dgm','netbios-ssn'],
  jump    => 'DROP',
  provider => 'ip6tables'
}

firewall { '0006 Disregard CIFS port 445':
  dport   => 'microsoft-ds',
  jump    => 'DROP',
  proto   => 'tcp',
  provider => 'ip6tables'
}

firewall { '0050-INPUT drop INVALID':
  state   => 'INVALID',
  jump    => 'DROP',
  provider => 'ip6tables'
}

firewall { '0051-INPUT allow RELATED,ESTABLISHED':
  state   => [ 'RELATED', 'ESTABLISHED' ],
  jump    => 'ACCEPT',
  provider => 'ip6tables'
}

firewall { '0053-INPUT allow ICMP':
  icmp    => '8',
  proto   => 'icmp',
  jump    => 'ACCEPT',
  provider => 'ip6tables'
}

firewall { '0055-INPUT allow DNS responses':
  proto   => 'udp',
  jump    => 'ACCEPT',
  sport => 'domain',
  provider => 'ip6tables'
}

# FORWARD
firewall { '9999-FORWARD drop default':
  chain => 'FORWARD',
  jump  => 'DROP',
  provider => 'ip6tables'
}

# OUTPUT
firewall { '0001-OUTPUT allow Loopback':
  chain    => 'OUTPUT',
  outiface => 'lo',
  jump     => 'ACCEPT',
  provider => 'ip6tables'
}

firewall { '0100-OUTPUT drop INVALID':
  chain   => 'OUTPUT',
  state   => 'INVALID',
  jump    => 'DROP',
  provider => 'ip6tables'
}
