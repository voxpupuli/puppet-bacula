require 'puppet'
module Puppet::Parser::Functions
  newfunction(:fragment) do |args|
    raise AugumentError("requires 3 arguments") unless args.size == 3
    # the file that we will eventually build
    file_arg = args[0]
    content  = args[1]
    order    = args[2]  
    path, file = file_arg.split(File::SEPARATOR, 2)
    # just takes content for starters.
    # I will support files and templates eventually
    hostname = lookupvar('hostname')
    vardir   = lookupvar('vardir')
    puts Puppet[:vardir]
    # directory where we store things on the server
    write_file = "#{vardir}/fragments/#{hostname}/#{path}/#{order}/#{file}"
#Puppet::Parser::Files.find_template(filename, scope.compiler.environment)
   # this should be moved to Puppet::Parser::Files
    #File.open(args[0], 'a') {|fd| fd.puts str }
  end
end
