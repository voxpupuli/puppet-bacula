Puppet::Parser::Functions::newfunction(:dirname, :type => :rvalue) do |args|
  File.dirname(args[0])
end

