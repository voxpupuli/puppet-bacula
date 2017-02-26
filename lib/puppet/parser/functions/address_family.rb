# This function takes an IP address and returns either INET or INET6 depending
# on the family of IP address received.
#
#
# @param [String] address IP address of either v6 or v4 family
# @example
#   address_family('127.0.0.1')
# @example
#   address_family('fc00::123')
# @return [String]
#
module Puppet::Parser::Functions
  newfunction(:address_family, type: :rvalue) do |args|
    address_string = args[0]

    require 'ipaddr'

    begin
      addr = IPAddr.new(address_string)
    rescue
      return false
    end

    return 'INET' if addr.ipv4?
    return 'INET6' if addr.ipv6?
    return false
  end
end
