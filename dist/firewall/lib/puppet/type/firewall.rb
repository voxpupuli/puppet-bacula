Puppet::Type.newtype(:firewall) do
  @doc = "Manipulate firewall rules"
  
  feature :parse_rules, "Parse the command string"
  feature :need_to_run?, "Determine if the command needs to be executed"
  feature :execute_changes, "Actually execute the changes"

  @doc = "Allows you to set iptable rules.

  Sample usage:
    
    firewall { \"0200-INPUT allow $name to http port\":
      chain  => 'INPUT',
      jump   => 'ACCEPT',
      proto  => 'tcp',
      source => $name,
      dport  => '80'
    }
  "
  
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:modified) do
      provider.modify
    end

    defaultto :present
  end
  
  newparam(:comment) do
    desc "The name of this task. Used for uniqueness"
    isnamevar
  end
  
  newparam(:chain) do
    desc "Holds value of iptables -A parameter.
    Possible values are: 'INPUT', 'FORWARD', 'OUTPUT', 'PREROUTING', 'POSTROUTING'.
    Default value is 'INPUT'"
    newvalues(:INPUT, :FORWARD, :OUTPUT, :PREROUTING, :POSTROUTING)
    defaultto "INPUT"
  end
  
  newparam(:table) do
    desc "Value to specify the packet matching table which the command should operate on. Optional.
    Possible values are: 'nat', 'mangle', 'filter' and 'raw'.
    Default value is 'filter'"
    newvalues(:nat, :mangle, :filter, :raw)
    defaultto "filter"
  end

  newparam(:proto) do
    desc "Value to specify the protocol of the rule or of the packet to check. Optional.
    Possible values are: 'tcp', 'udp', 'icmp', 'esp', 'ah', 'vrrp', 'igmp', 'all'.
    Default value is 'all'"
    newvalues(:tcp, :udp, :icmp, :esp, :ah, :vrrp, :igmp, :all)
    defaultto "tcp"
  end

  newparam(:jump) do
    desc "Value to specify the target of the rule.
    Possible values are: 'ACCEPT', 'DROP', 'REJECT', 'DNAT', 'SNAT', 'LOG', 'MASQUERADE', 'REDIRECT'."
    newvalues(:ACCEPT, :DROP, :REJECT, :DNAT, :SNAT, :LOG, :MASQUERADE, :REDIRECT, :MARK)
    isrequired
  end

  newparam(:source) do
    desc "Value to specify the source address. Address can be either a network name, a hostname,
    a network IP address (with /mask), or a plain IP address. Accepts a single string or array. Optional"
    
    munge do |value|
      if value.kind_of?(Array)
        value.join(',')
      else
        super
      end
    end
  end

  newparam(:destination) do
    desc "Valure to specify the destination address. Address can be either a network name, a hostname,
    a network IP address (with /mask), or a plain IP address. Accepts a single string or array. Optional"
    
    munge do |value|
      if value.kind_of?(Array)
        value.join(',')
      else
        super
      end
    end
  end

  newparam(:sport) do
    desc "Value to specify the source port. If an array is specified, values will be passed to the multiport
    module. This parameter can only be used when the proto value is 'tcp' or 'udp'. Optional"

    munge do |value|
      if value.kind_of?(Array)
        ports = []
        value.each do |port|
          ports << Socket.getservbyname(port) unless port.kind_of?(Integer)
        end
        ports.join(',')
      else
        Socket.getservbyname(value)
      end
    end
  end

  newparam(:dport) do
    desc "Value to specify the destination port. If an array is specified, values will be passed to the multiport
    module. This parameter can only be used when the proto value is 'tcp' or 'udp'. Optional"
    
    munge do |value|
      if value.kind_of?(Array)
        ports = []
        value.each do |port|
          ports << Socket.getservbyname(port) unless port.kind_of?(Integer)
        end
        ports.join(',')
      else
        Socket.getservbyname(value)
      end
    end
  end

  newparam(:iniface) do
    desc "Value to specify the name of an interface via which a packet was received. This parameter can only be
    used when the chain value is 'INPUT', 'FORWARD', or 'PREROUTING'. Optional"
  end

  newparam(:outiface) do
    desc "Value to specify the name of an interface via which a packet is going to be sent. This parameter can only be
    used when the chain value is 'INPUT', 'FORWARD', or 'PREROUTING'. Optional"
  end

  newparam(:tosource) do
    desc "Value to specify that the source address of the packet should be modified. This parameter can only be use when
    the table value is 'nat' and the chain is 'POSTROUTING'. Uses the SNAT target extension. Optional"
  end

  newparam(:todest) do
    desc "Value to specify that the destination address of the packet should be modified. This parameter can only be use when
    the table value is 'nat' and the chain is 'POSTROUTING'. Uses the DNAT target extension. Optional"
  end

  newparam(:toports) do
    desc "Value to specify a destination port or range of ports to use. This parameter can only be used when the table value is
    'nat' and the chain value is 'POSTROUTING' or 'OUTPUT'. Uses the REDIRECT target extension. Optional."
  end

  newparam(:reject) do
    desc "Value to specify the type of error packet returned. This parameter can only be used when the chain value is 'INPUT',
    'FORWARD', or 'OUTPUT'. Uses the REJECT target extension. Optional
    Possible values are: 'net-unreachable', 'host-unreachable', 'port-unreachable', 'proto-unreachable', 'net-prohibited', host-prohibited', or 'admin-prohibited'"
  end

  newparam(:set_mark) do
    desc "Value to specify a mark. This parameter can only be used when the table value is mangle. Optional.
    Value must be an integer."
  end

  newparam(:log_level) do
    desc "Value to specify the logging level."
  end

  newparam(:log_prefix) do
    desc "Value to specify the log message prefix. This value can be up to 29 letters long. Optional."
    validate do |value|
      if value.length > 29
        raise Puppet::Error, "The log prefix cannot be more than 29 letters long"
      end
    end
  end

  newparam(:icmp) do
    desc "Value to specify the ICMP type. This value can be a numeric ICMP type or one of the ICMP type names show by `iptables -p icmp -h`. Optional."
  end

  newparam(:state) do
    desc "Value to specify the connection tracking state. This value can be either a string or array. Optional.
    Possible values are: 'INVALID', 'ESTABLISHED', 'NEW', 'RELATED'."
    #newvalues(:INVALID, :ESTABLISHED, :NEW, :RELATED)
    
    munge do |value|
      if value.kind_of?(Array)
        value.join(',')
      else
        super
      end
    end
  end

  newparam(:limit) do
    desc "Value to specify the a limited matching rate. Optional.
    Example values are: '50/sec', '40/min', '30/hour', '10/day'."
  end

  newparam(:burst) do
    desc "Value to specify a maximum initial number of packets to match. Optional.
    Example values are: '5', '10'."
  end

  newparam(:redirect) do
    desc "Value to specify the destination port or range of ports to use to redirect the packet to the machine itself. Optional."
  end

  newparam(:rules) do
    desc "Empty parameter used to cache the current ruleset."
  end
  
  validate do
    if self[:sport]
      unless self[:proto].to_s =~ /(tcp|udp)/
        raise Puppet::Error, "A source port value can only be used when the proto value is 'tcp' or 'udp'."
      end
    end
  
    if self[:dport]
      unless self[:proto].to_s =~ /(tcp|udp)/
        raise Puppet::Error, "A destination port value can only be used when the proto value is 'tcp or 'udp'."
      end
    end
  
    if self[:iniface]
      unless self[:chain].to_s =~ /(INPUT|FORWARD|PREROUTING)/
        raise Puppet::Error, "An iniface value can only be used when the chain value is 'INPUT', 'FORWARD', or 'PREROUTING'."
      end
    end
  
    if self[:outiface]
      unless self[:chain].to_s =~ /(OUTPUT|FORWARD|PREROUTING)/
        raise Puppet::Error, "An outiface value can only be used when the chain value is 'OUTPUT', 'FORWARD', or 'PREROUTING'."
      end
    end
  
    if self[:tosource]
      unless self[:table].to_s == 'nat' && self[:chain].to_s == 'POSTROUTING'
        raise Puppet::Error, "A tosource value can only be used when the table value is 'nat' and the chain value is 'POSTROUTING'"
      end
    end
  
    if self[:todest]
      unless self[:table].to_s == 'nat' && self[:chain].to_s == 'POSTROUTING'
        raise Puppet::Error, "A todest value can only be used when the table value is 'nat' and the chain value is 'POSTROUTING'"
      end
    end
  
    if self[:toports]
      unless self[:table].to_s == 'nat' && self[:chain].to_s =~ /(POSTROUTING|OUTPUT)/
        raise Puppet::Error, "A toports value can only be used when the table value is 'nat' and the chain value is 'POSTROUTING' or 'OUTPUT'."
      end
    end

    if self[:reject]
      unless self[:chain].to_s =~ /(INPUT|FORWARD|OUTPUT)/
        raise Puppet::Error, "A reject value can only be set when the chain value is 'INPUT', 'FORWARD', or 'OUTPUT'."
      end
    end

    if self[:set_mark]
      unless self[:jump].to_s == 'MARK' && self[:table] == 'mangle' && self[:set_mark].kind_of?(Integer)
        raise Puppet::Error, "A set_mark valure can only be an integer, and can only be set when the jump value is 'MARK' and the table value is 'mangle'"
      end
    end
  end
end
