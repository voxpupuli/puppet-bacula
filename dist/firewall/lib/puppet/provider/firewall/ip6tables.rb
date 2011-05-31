begin
  require 'socket'
rescue
  Puppet.warning "The Ruby standard library is required to use this provider"
end

Puppet::Type.type(:firewall).provide :ip6tables, :parent => :iptables, :src => :iptables do
  desc 'Ip6tables type provider'

  commands :iptables => "/sbin/ip6tables"
  commands :ipsave => "/sbin/ip6tables-save"
  commands :iprestore => "/sbin/iptables-restore"
  
  mk_resource_methods

  def create
    debug "Creating rule %s" % resource[:name]
    `ip6tables #{args.join(' ')}`
  end
  
  def destroy
    debug "Destroying rule %s" % resource[:name]
    `ip6tables #{args.join(' ').sub(/\-A/, '-D')}`
  end
end
