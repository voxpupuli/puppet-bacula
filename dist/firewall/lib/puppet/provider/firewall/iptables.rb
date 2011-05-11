require 'puppet/provider/firewall'

begin
    require 'socket'
rescue
    Puppet.warning "The Ruby standard library is required to use this provider"
end

Puppet::Type.type(:firewall).provide :iptables, :parent => Puppet::Provider::Firewall do
  @doc = "Iptables type provider"

  commands :iptables => '/sbin/iptables'
  commands :ipsave => '/sbin/iptables-save'
  commands :iprestore => '/sbin/iptables-restore'

  # iptables is a Linux thang, yo.
  confine :operatingsystem => [:linux, :debian, :ubuntu, :centos, :redhat]
  defaultfor :operatingsystem => [:linux, :debian, :ubuntu, :centos, :redhat]

  IptablesVer = iptables('-V').slice(/\d\.\d.\d/)

  # Map of parameters to iptables arguments. To ensure consistency, multiport is always used no matter how many
  # ports are specified.
  PropertyMap = {
    :table => "-t",
    :chain => "-A",
    :source => "-s",
    :destination => "-d",
    :iniface => "-i",
    :outiface => "-o",
    :proto => "-p",
    :sport => "-m multiport --sports",
    :dport => "-m multiport --dports",
    :icmp => "-m icmp --icmp-type",
    :state => "-m state --state",
    :comment => "-m comment --comment",
    :limit => "--limit",
    :burst => "--limit-burst",
    :jump => "-j",
    :todest => "--to-destination",
    :tosource => "--to-source",
    :reject => "--reject-with",
    :set_mark   => "--set-mark",
    :log_level => "--log-level",
    :log_prefix => "--log-prefix",
    :redirect => "--to-ports"
  }

  # This is necessary for the order of the iptables arguments 
  Fields = [:table, :chain, :source, :destination, :iniface, :outiface, :proto, :sport, :dport, :tosource, :todest, :reject, :set_mark, :log_level, :log_prefix, :comment, :state, :icmp, :limit, :burst, :redirect, :jump]
  
  mk_resource_methods
 
  # Backticks are used to work around the quoted comment string
  # Create the rule
  def create
    debug "Creating rule %s" % resource[:name]
    `iptables #{args.join(' ')}`
  end

  # Modify the existing rule
  def modify
    debug "Updating modified rule %s" % resource[:name]
    pos = position
    `iptables #{args.join(' ')}`
    `iptables -D #{resource[:chain]} #{pos - 1}`
  end

  # Destroy the rule
  def destroy
    debug "Destroying rule %s" % resource[:name]
    `iptables #{args.join(' ').sub(/\-I/, '-D')}`
  end

  # Check whether the rule exists or has been modified
  def exists?
    debug "Checking whether rule %s exists or is insync" % resource[:name]
    resource[:rules] = self.class.instances
    insync?
  end

  def self.instances
    debug "Converting existing rules to resources"
    rules = []
    ipsave.lines do |line|
      unless line =~ /^\#\s+|^\:\S+|^COMMIT/
        if line =~ /^\*/
          table = line.sub(/\*/, "")
        else
          if hash = rule_to_hash(line, table)
            rules << new(hash)
          end
        end
      end
    end
    rules
  end

  def self.rule_to_hash(line, table)
    hash = {}
    keys = []
    values = line.dup

    # A little reverse magic to prevent slicing the simpler values (-s, -t) from the
    # larger stuff (--m state --state)
    Fields.reverse.each do |k|
      if values.slice!(PropertyMap[k])
        keys << k
      end
    end

    # Some more reverse magic, to ensure keys and values match
    # The regex here is used to remove the leading and trailing quotes from the comment string.
    keys.zip(values.scan(/"[^"]*"|\S+/).reverse) { |f, v| hash[f] = v }
    hash[:provider] = self.name.to_s
    if hash[:comment]
      hash[:name] = hash[:comment].gsub!(/^"(.*?)"$/,'\1')
    else
      # Push rule to the end of the chain if it does not have a comment
      hash[:name] = hash[:comment] = "9999 iptables-rule"
    end
    hash
  end

  # Determine if iptables supports comments
  def comment_support
    if IptablesVer.split('.')[1].to_i >= 3
      debug "Checking if iptables supports comments? True"
      true
    else
      debug "Checking if iptables supports comments? False"
      false
    end
  end

  # Determine the position where the rule should be inserted.
  def position
    debug "Determining rule position"
    rules = []
    resource[:rules].each do |rule|
      if rule.chain == resource[:chain].to_s
        rules << rule.name.slice(/^\d+/).to_i
      end
    end
    
    rules = rules.sort
    
    if ! rules.empty?
      begin
        rules.each do |a|
          if a > resource[:name].slice(/^\d+/).to_i
            @pos = rules.index(a) + 1
            raise 'found position'
          end
        end
      rescue
        @pos
      else
        rules.count + 1
      end
    else
      return 1
    end
  end

  # Compile args into an array
  def args
    debug "Building args"
    arguments = []
    Fields.each do |k|
      if k.to_s == 'comment'
        value = "\"#{resource[:comment]}\""
      else
        if resource[k].kind_of?(Array)
          value = resource[k].join(',')
        else
          value = resource[k]
        end
      end
      if ! value.nil?
        arguments << PropertyMap[k]
        arguments << value
      end
    end
    arguments[2] = "-I"
    arguments.insert(4, position)
    arguments
  end
end
