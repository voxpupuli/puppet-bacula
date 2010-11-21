module Puppet::Parser::Functions
  newfunction(:date, :type => :rvalue ) do 
    time = Time.new
    time.strftime("%Y%m%d%H")
  end
end

