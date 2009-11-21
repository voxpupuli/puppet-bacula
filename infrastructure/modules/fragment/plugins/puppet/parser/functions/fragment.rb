include Puppet::Parser::Files
module Puppet::Parser::Functions
  newfunction(:fragment) do |args|
    raise AugumentError "requires 3 arguments" if args.size != 3
    # the file that we will eventually build
    file_arg = args[0]
    content  = args[1]
    order    = args[2]  
    path, file = split_file_path(file)
    # just takes content for starters.
    # I will support files and templates eventually
    hostname = lookupvar('hostname')
    vardir   = lookupvar('vardir')
    put vardir
    # directory where we store things on the server
    write_file = "/tmp/puppet/#{hostname}/#{path}/#{order}/#{file}"


#Puppet::Parser::Files.find_template(filename, scope.compiler.environment)
   # this should be moved to Puppet::Parser::Files
  


    File.open(args[0], 'a') {|fd| fd.puts str }
  end
end

def file_fragment_in_module() {
  # if full path is specified, use that
  if fragment =~ /^#{File::SEPARATOR}/
    return template
  end
  # otherwise, assume that a module is specified
}
