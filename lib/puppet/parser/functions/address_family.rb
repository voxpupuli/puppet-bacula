module Puppet::Parser::Functions
  newfunction(:address_family, :type => :rvalue) do |args|
    address_string = args[0]

    require 'ipaddr'

    begin
      addr = IPAddr.new(address_string)
    rescue => e
      return false
    end

    if addr.ipv4?
      return 'INET'
    elsif addr.ipv6?
      return 'INET6'
    else
      return false
    end
  end
end