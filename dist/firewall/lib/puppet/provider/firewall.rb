class Puppet::Provider::Firewall < Puppet::Provider
  # Prefetch existing rules
  def self.prefetch(rules)
    instances.each do |prov|
      if rule = rules[prov.name]
        rule.provider = prov
      end
    end
  end

  def properties
    if @property_hash.empty?
      @property_hash = query || {:ensure => :absent}
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end
  
  def query
    resource[:rules].each do |rule|
      if rule.name == self.name or rule.name.downcase == self.name
        return rule.properties
      end
    end
    nil
  end
  
  # Check whether the rules exists or outdated
  def insync?
    unless properties[:ensure] == :absent
      properties.each do |k, v|
        if resource[k].to_s != v
          resource[:ensure] = :modified
          break false
        end
      end
    end
  end
end
